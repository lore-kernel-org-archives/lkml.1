Return-Path: <linux-kernel-owner+w=401wt.eu-S1753695AbZJAWj0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753695AbZJAWj0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 18:39:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753332AbZJAWjZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 18:39:25 -0400
Received: from mail-px0-f179.google.com ([209.85.216.179]:64923 "EHLO
	mail-px0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753270AbZJAWjZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 18:39:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=BGey70H/Vw/Ojwas1z4RG59zDv1pL1+Gyu7Y8litwhVpqC7KdkYH+V9M8WKD0/0t4O
         nDIRp9BUTPjTOpmHjPwyQlHvTNR0vTUMF3sTgzsk47DZwZf+Q3L+s/rpFZoRGrRRzNOM
         IKaM0whSwtOcS1s79/GACr6KaeicR1ubdv2EQ=
MIME-Version: 1.0
In-Reply-To: <200909302328.56892.elendil@planet.nl>
References: <20090930203322.E7963F88DD@sepang.rtg.net>
	 <200909302328.56892.elendil@planet.nl>
Date: Thu, 1 Oct 2009 15:39:28 -0700
X-Google-Sender-Auth: 56e7202dff53da1e
Message-ID: <9929d2390910011539m4fb6619ag416f66f4f7145b5d@mail.gmail.com>
Subject: Re: [PATCH] e1000e: Fix PCIE error message
From: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To: Frans Pop <elendil@planet.nl>
Cc: Tim Gardner <timg@tpi.com>, jesse.brandeburg@intel.com,
       bruce.w.allan@intel.com, e1000-devel@lists.sourceforge.net,
       john.ronciak@intel.com, linux-kernel@vger.kernel.org,
       peter.p.waskiewicz.jr@intel.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 30, 2009 at 14:28, Frans Pop <elendil@planet.nl> wrote:
> Tim Gardner wrote:
>> Subject: [PATCH] e1000e: Fix PCIE error message
>>
>> BugLink: http://bugs.launchpad.net/bugs/436370
>>
>> The error returned by pci_enable_pcie_error_reporting() is ignored, so
>> print a notice instead of an error. Users tends to freak out
>> when they see messages like this.
>
> There's already a patch in the pipeline that removes the error message
> completely. See http://lkml.org/lkml/2009/8/21/39 for the final version.
>
> I'm not sure why it isn't included in 2.6.31 yet as it was acked by Jeff.
>

I will add Fran's patch to my queue of patches and resend to
Dave/netdev and I will make sure it also gets submitted to 2.6.31
stable tree once it gets merged upstream.  I apologize for not
catching that this got overlooked.

-- 
Cheers,
Jeff
