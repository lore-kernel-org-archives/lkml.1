Return-Path: <linux-kernel-owner+w=401wt.eu-S1762285AbXJPLcn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762285AbXJPLcn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2007 07:32:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759437AbXJPLcd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Oct 2007 07:32:33 -0400
Received: from fk-out-0910.google.com ([209.85.128.184]:7329 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759325AbXJPLcc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2007 07:32:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:to:cc:subject:message-id:organization:x-mailer:mime-version:content-type:content-transfer-encoding:from;
        b=ssKqfsW3/JPfWbdJaiwzaijU4NZvkgWS2LmN36sdi5gWkQb+KlgC2rzmZDsmhhKXPfZEBv+0/RaUupItLT2eTG8ShyOskXJ+wg86O25op6QuntOW1sInkdeqIblHseE4rDHZ3F4JKmuOhbaIXRfw0kBEu/c+jsImZFbQ/qC9l6U=
Date: Tue, 16 Oct 2007 13:40:50 -0700
To: dmitry <dtor@insightbb.com>
Cc: linux-input <linux-input@atrey.karlin.mff.cuni.cz>,
       linux-main <linux-kernel@vger.kernel.org>
Subject: Power button policy and mechanism
Message-Id: <20071016134050.f7106efe.Kristoffer.Ericson@Gmail.com>
Organization: JLime
X-Mailer: Sylpheed 2.4.5 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
From: Kristoffer Ericson <kristoffer.ericson@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Greetings Dmitry,

Is the suggested approach on handling powerbutton (in keyboard driver) to simply push out the event and let userland handle it? 
The reason Im asking this is because as you might know Im maintainer for two mini-laptop style pda's (HP7xx & HP6xx)
and it would simplify my life alot if I didn't need to depend on userland applications to be able to suspend/resume.

For instance HP6XX receives an interrupt call whenever the powerbutton is pressed. Now I could just push out the event and let another program handle it but considering it would take a minimum amount of lines to let it simply suspend/resume I feel its a waste.

Previously the hp6xx has been allowed to do this "policy" way but that was when LinuxSH stod as a side branch to main tree. Now
when everything gets merged into mainline I need to decide how to do this.

This is mainly an embedded issue, but I feel it's quite important. It should apply to other devices also like for example Zaurus branches (those with keyboard and designated power button).

So in short:
1. Does mainline policy allow static power button events inside kernel (power button == suspend/resume)?
	Why/Why Not?
2. Seeing as my knowledge about this area isn't the best I would appreciate all opinions on the subject from the gurus.

Best wishes
Kristoffer Ericson

-- 
Kristoffer Ericson <Kristoffer.Ericson@Gmail.com>
