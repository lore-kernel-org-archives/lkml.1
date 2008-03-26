Return-Path: <linux-kernel-owner+w=401wt.eu-S1759141AbYCZLHX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759141AbYCZLHX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2008 07:07:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757215AbYCZLHN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Mar 2008 07:07:13 -0400
Received: from smtp8-g19.free.fr ([212.27.42.65]:37192 "EHLO smtp8-g19.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755585AbYCZLHM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2008 07:07:12 -0400
Date: Wed, 26 Mar 2008 12:07:13 +0100
From: Emmanuel Florac <eflorac@intellique.com>
To: "Bart Van Assche" <bart.vanassche@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: RAID-1 performance under 2.4 and 2.6
Message-ID: <20080326120713.24cb8093@harpe.intellique.com>
In-Reply-To: <e2e108260803260142o34c33e7ajf395d5cb62824cb4@mail.gmail.com>
References: <20080325194306.4ac71ff2@galadriel.home>
	<e2e108260803260142o34c33e7ajf395d5cb62824cb4@mail.gmail.com>
Organization: Intellique
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.12.9; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le Wed, 26 Mar 2008 09:42:19 +0100
"Bart Van Assche" <bart.vanassche@gmail.com> écrivait:

> Keep in mind that the above test tests two subsystems at the same
> time: RAID-1 + the filesystem on top of it.

I'm using XFS usually, and I've also checked against the raw devices
and it looks the same (2.4 still faster). I must add that the difference
is somewhat reduced when using a single disk drive vs. RAID-1,
obviously due to different buffering policy in the RAID subsystem.

-- 
----------------------------------------
Emmanuel Florac     |   Intellique
----------------------------------------

