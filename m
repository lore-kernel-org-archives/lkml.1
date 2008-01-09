Return-Path: <linux-kernel-owner+w=401wt.eu-S1754228AbYAINjc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754228AbYAINjc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2008 08:39:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751371AbYAINjY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jan 2008 08:39:24 -0500
Received: from def92-3-81-56-114-101.fbx.proxad.net ([81.56.114.101]:41180
	"EHLO barad-dur.regala.cx" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751149AbYAINjY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2008 08:39:24 -0500
To: Tuomo Valkonen <tuomov@iki.fi>
Cc: linux-kernel@vger.kernel.org
Subject: Re: The ext3 way of journalling
References: <slrnfo77tv.2rr.tuomov@jolt.modeemi.cs.tut.fi>
	<18307.42821.166376.732473@stoffel.org>
	<slrnfo7auq.6m2.tuomov@jolt.modeemi.cs.tut.fi>
From: Mathieu SEGAUD <mathieu.segaud@regala.cx>
Date: Wed, 09 Jan 2008 14:39:23 +0100
In-Reply-To: <slrnfo7auq.6m2.tuomov@jolt.modeemi.cs.tut.fi> (Tuomo Valkonen's message of "Tue\, 8 Jan 2008 16\:59\:06 +0000 \(UTC\)")
Message-ID: <871w8r6ruc.fsf@barad-dur.regala.cx>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vous m'avez dit récemment :

> On 2008-01-08, John Stoffel <john@stoffel.org> wrote:
>> Look at your filesystems, using 'tune2fs' and see if the ext3 journal
>> is actually turned on and used.  If it's not, then I can see why
>> you're having problems on reboots.  
>
> Journalling is on, but it's no use because the superblock always has
> corrupted last-checked time at boot. "File system check forced: 31352
> days since last check" or so. 

fix your hardware clock then

-- 
Mathieu
