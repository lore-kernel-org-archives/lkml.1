Return-Path: <linux-kernel-owner+w=401wt.eu-S1757999AbYDBRgh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757999AbYDBRgh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2008 13:36:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756769AbYDBRg0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Apr 2008 13:36:26 -0400
Received: from wf-out-1314.google.com ([209.85.200.174]:11954 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756739AbYDBRg0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2008 13:36:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=from:organization:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=Nl8TGwPYhrWElOUrOafPTKEbLp7P8wDfhRKKTPyA1TCHDn3t3fBri+SCAxiIpO5uVxglPdSC9AED4tUJ5cc6Xwd1opbIa6xT8kVHErLkvu0Cp7JJHVtGtyK5gVzfrEGyYdG0gyUKDj5vUVr+oinBlNz49rJ1DXuOLa94bVH7Ey8=
From: Balaji Rao <balajirrao@gmail.com>
Organization: National Institute of Technology, Karnataka
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: Re: 2.6.25-rc5.git4 regression PS/2 mouse not detected/working
Date: Wed, 2 Apr 2008 23:00:13 +0530
User-Agent: KMail/1.9.6 (enterprise 0.20071012.724442)
Cc: Yanko Kaneti <yaneti@declera.com>, linux-input@vger.kernel.org,
       linux-kernel@vger.kernel.org, mingo@elte.hu,
       Thomas Gleixner <tglx@linutronix.de>
References: <1205775229.25146.11.camel@indigo.declera.com> <200804022038.33245.balajirrao@gmail.com> <20080402113043.ZZRA012@mailhub.coreip.homeip.net>
In-Reply-To: <20080402113043.ZZRA012@mailhub.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804022300.14164.balajirrao@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 02 April 2008 09:03:28 pm Dmitry Torokhov wrote:
> Hi Blaji,
> 
> On Wed, Apr 02, 2008 at 08:38:33PM +0530, Balaji Rao wrote:
> > 
> > Coincidentally even I hit upon this bug a couple of days ago after enabling 
> > HPET in my BIOS. A quick check told me that IRQ 12 which the patch assigns to 
> > the HPET device is used by the PS/2 mouse as well. This makes the mouse 
> > inactive.
> > 
> > I am working on this.. I am not sure if the PS/2 code is misbehaving though..
> >
> 
> Normally IRQ12 can not be shared on X86 if PS/2 mouse is present.
> If PCI side tries to grab the IRQ then ISA (legacy) side will never
> see its interrupts coming.
> 
OK. So, I need to specifically check for IRQ12 being assigned and avoid it ?

-- 
regards,
balaji rao
Dept. of Mechanical Engineering,
National Institute of Technology Karnataka, India
