Return-Path: <linux-kernel-owner+w=401wt.eu-S1753902AbZAGLhN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753902AbZAGLhN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2009 06:37:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751557AbZAGLhA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Jan 2009 06:37:00 -0500
Received: from rv-out-0506.google.com ([209.85.198.238]:16764 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750817AbZAGLg7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2009 06:36:59 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=MfFMoh1pYxET0K9QNiGd/sop9FDnBOYcFlO/ayh0394Q/Rc9R4nUq0xDRBa2U88TNT
         +NX+zUJQrOKRWt5O7uIx6DZPqQw45W579F28ddErihrl2GDd5LdJdVFWH5edYtw7/lNK
         UM/2iazcX57g3H9InLsyBMSI5yY32PAXciREQ=
Message-ID: <b6a2187b0901070336u1cb0bc94i1e47a68d8ea671c@mail.gmail.com>
Date: Wed, 7 Jan 2009 19:36:57 +0800
From: "Jeff Chua" <jeff.chua.linux@gmail.com>
To: "Pekka Enberg" <penberg@cs.helsinki.fi>
Subject: Re: [ 286.547348] BUG: unable to handle kernel paging request at 6b6b6b6b
Cc: "Heiko Carstens" <heiko.carstens@de.ibm.com>,
       "Justin P. Mattock" <justinmattock@gmail.com>,
       linux-kernel@vger.kernel.org, "Rusty Russell" <rusty@rustcorp.com.au>
In-Reply-To: <1231319946.14720.7.camel@penberg-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <4963F368.7080909@gmail.com>
	 <84144f020901062248j5d406656wb21130d914c7749d@mail.gmail.com>
	 <84144f020901070030k6fb888f6n84255078e4885d28@mail.gmail.com>
	 <20090107091534.GA4633@osiris.boeblingen.de.ibm.com>
	 <1231319946.14720.7.camel@penberg-laptop>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 7, 2009 at 5:19 PM, Pekka Enberg <penberg@cs.helsinki.fi> wrote:
> On Wed, 2009-01-07 at 10:15 +0100, Heiko Carstens wrote:
>> I missed to convert disable_nonboot_cpus to
>> stop_machine_create/destroy.
>> So it's a use before-even-allocated bug.
>> The patch below should hopefully fix it:
>> Subject: [PATCH] cpu hotplug: add stop_machine_create/destroy to disable_nonboot_cpus
> Looks good to me!

This also fixes the suspend-to-ram/disk problem. Without it, the
system will just hang.

Thanks for the fix.

Thanks,
Jeff.
