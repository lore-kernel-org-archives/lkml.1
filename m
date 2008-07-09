Return-Path: <linux-kernel-owner+w=401wt.eu-S1756032AbYGIVof@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756032AbYGIVof (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2008 17:44:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752696AbYGIVo0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jul 2008 17:44:26 -0400
Received: from fg-out-1718.google.com ([72.14.220.158]:14312 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751967AbYGIVoZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2008 17:44:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:in-reply-to:references:x-mailer
         :mime-version:content-type:content-transfer-encoding;
        b=pjv0WuHzpcTuHRWiws5dHzY4sWm4V4HczScWSYB+Wh90CSBSZZtDhVCyV5xNo6mFPk
         m3jaunYvm9/vquyyLFGimB4fdFf/Psb+QxlPN0f6/+MSLCOkY4GMQ+pc02IkNt1RDhJy
         RquIDVxxJF5KuQoe+tjycZM7jbDCQMmDCd3Zg=
Date: Wed, 9 Jul 2008 23:44:19 +0200
From: Cezary Jackiewicz <cezary.jackiewicz@gmail.com>
To: Ivo van Doorn <ivdoorn@gmail.com>
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
       ak@linux.intel.com, Len Brown <lenb@kernel.org>,
       Richard Purdie <rpurdie@rpsys.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Subject: Re: [RESEND] [PATCH -next 2/2] acpi,rfkill,backlight: comapl-laptop
 update - use rfkill switch subsystem
Message-ID: <20080709234419.12d6eabc@debian>
In-Reply-To: <200807092333.01355.IvDoorn@gmail.com>
References: <20080709231059.778d16f4@debian>
	<200807092333.01355.IvDoorn@gmail.com>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dnia 2008-07-09, o godz. 23:33:01
Ivo van Doorn <ivdoorn@gmail.com> napisa³(a):

> On Wednesday 09 July 2008, Cezary Jackiewicz wrote:
> > From: Cezary Jackiewicz <cezary.jackiewicz@gmail.com>
> > 
> > Remove unnecessary attributes, use rfkill switch subsystem.
> 
> I'm missing a call to rfkill_force_state() to inform the rfkill subsystem that
> the key has been toggled. This function should be called when the hardware
> has raised the interrupt about the pressed event, or when the function
> which polls the register notices the state change.
> 
> As the patch works now, it means that the driver will only listen to
> events coming from rfkill and it doen't provide any updates itself.
> 
> Ivo

Does calling rfkill_force_state () is mandatory? This driver implement 
get_state() hook, @state is always up-to-date.

-- 
 Cezary


