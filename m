Return-Path: <linux-kernel-owner+w=401wt.eu-S1754131AbYBQSl5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754131AbYBQSl5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2008 13:41:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751859AbYBQSlt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Feb 2008 13:41:49 -0500
Received: from fg-out-1718.google.com ([72.14.220.152]:37501 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751226AbYBQSls (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2008 13:41:48 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=vpKcvW7fpW1xNpEEgkRlqVMU3j2giAjoQvycE7HnHEKXrKmsujFCaBiY9pISkt6m1FX+hSK292pB25OEIrhctiBKh7jAOGx5meUeJuZH+DWxOZPK6C2CJPlrBQPaB64qHPIqEXLONh34MN59KZxQIE7V0V/aArcFcWmJ2oouoZg=
Date: Sun, 17 Feb 2008 21:41:19 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Andi Kleen <ak@suse.de>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86 cleanup: suspend_asm_64.S - use X86_CR4_PGE
	instead of numeric value
Message-ID: <20080217184119.GB31968@cvg>
References: <20080208214913.GB6787@cvg> <20080217181716.GY6006@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080217181716.GY6006@elte.hu>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Ingo Molnar - Sun, Feb 17, 2008 at 07:17:16PM +0100]
| 
| * Cyrill Gorcunov <gorcunov@gmail.com> wrote:
| 
| > By including <asm/processor-flags.h> we're allowed to use X86_CR4_PGE 
| > instead of numeric constant.
| > 
| > md5 sums of compiled files are differ due to this inclusion but .text 
| > section remains the same.
| 
| thanks Cyrill, picked it up. (the merged version is below - the target 
| files moved meanwhile)
| 
| 	Ingo
| 
[...]

Thanks, Ingo

		- Cyrill -
