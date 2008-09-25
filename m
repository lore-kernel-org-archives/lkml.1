Return-Path: <linux-kernel-owner+w=401wt.eu-S1755602AbYIYVps@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755602AbYIYVps (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2008 17:45:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754078AbYIYVpj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Sep 2008 17:45:39 -0400
Received: from mail-gx0-f16.google.com ([209.85.217.16]:39897 "EHLO
	mail-gx0-f16.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753773AbYIYVpi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2008 17:45:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=QIJcg4myr/jzyt7YM9M4nTzbxHV7vCw2HkAf3qzx6whsxvOBfI+F0OVX8E6oTHIKs4
         0cEltAG44R7W0xqWGPh6MVxc4A8X0STjBnEb7+MCBhEEHLuJd+O1dyTSF3iX3GyJf3l/
         MVzvpFDl+hfU3pATfCCIot2arhSp2sS/94q3c=
Message-ID: <21d7e9970809251445s216efcc3kaba639d5e29c51aa@mail.gmail.com>
Date: Fri, 26 Sep 2008 07:45:37 +1000
From: "Dave Airlie" <airlied@gmail.com>
To: "Jesse Brandeburg" <jesse.brandeburg@gmail.com>
Subject: Re: [Bug #11382] e1000e: 2.6.27-rc1 corrupts EEPROM/NVM
Cc: "Jiri Kosina" <jkosina@suse.cz>, "Jesse Barnes" <jbarnes@virtuousgeek.org>,
       "Frans Pop" <elendil@planet.nl>, "Jeff Garzik" <jeff@garzik.org>,
       davem@davemloft.net, jeffrey.t.kirsher@intel.com, david.vrabel@csr.com,
       rjw@sisk.pl, linux-kernel@vger.kernel.org,
       kernel-testers@vger.kernel.org, chrisl@vmware.com,
       "Ingo Molnar" <mingo@elte.hu>
In-Reply-To: <4807377b0809251442x67e4e9eia706b70ae1c177ca@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080923.150722.141587696.davem@davemloft.net>
	 <200809251156.10648.jbarnes@virtuousgeek.org>
	 <alpine.LNX.1.10.0809252218470.3389@pegasus.suse.cz>
	 <200809251236.12287.jbarnes@virtuousgeek.org>
	 <alpine.LNX.1.10.0809252234400.3389@pegasus.suse.cz>
	 <21d7e9970809251406gb2bdacbuf9ff1bde3d118cdb@mail.gmail.com>
	 <4807377b0809251442x67e4e9eia706b70ae1c177ca@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 26, 2008 at 7:42 AM, Jesse Brandeburg
<jesse.brandeburg@gmail.com> wrote:
> On Thu, Sep 25, 2008 at 2:06 PM, Dave Airlie <airlied@gmail.com> wrote:
>> I'd target three areas PAT, pciaccess and e1000e itself.
>
> ubuntu has CONFIG_X86_PAT disabled for at least i386 arch, maybe that
> is relevant.
>

It rules out PAT I suppose, they have seen the issue as well.

Dave.
