Return-Path: <linux-kernel-owner+w=401wt.eu-S1753820AbXDJTp6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753820AbXDJTp6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2007 15:45:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753812AbXDJTp6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Apr 2007 15:45:58 -0400
Received: from inetc.connecttech.com ([64.7.140.42]:1700 "EHLO
	inetc.connecttech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753820AbXDJTp5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2007 15:45:57 -0400
From: "Stuart MacDonald" <stuartm@connecttech.com>
To: "'Paolo Ornati'" <ornati@fastwebnet.it>
Cc: <linux-kernel@vger.kernel.org>
Subject: RE: Alternative to 'git bisect visualize'?
Date: Tue, 10 Apr 2007 15:45:33 -0400
Organization: Connect Tech Inc.
Message-ID: <05ad01c77ba8$cd753040$294b82ce@stuartm>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Priority: 3 (Normal)
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook, Build 10.0.6626
In-Reply-To: <20070410100347.44657750@localhost>
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.3028
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Paolo Ornati [mailto:ornati@fastwebnet.it] 
> I think this should work:
> 
> 1) look at "git-bisect log" and take the last good/bad pair
> 
> 2) "cat .git/refs/heads/bisect" to see where you are now
> 
> 3) git-log --pretty=oneline GOOD..BAD
> 
> 4) search for the current commit (found in #2) with "/CURRENT_COMMIT",
> now move around and choose another commit to test
> 
> 5) git-reset --hard COMMIT_TO_TEST

That is exactly what I needed, many many thanks. I have moved off the
broken area of commits and am back into bisecting.

Where would be the appropriate place to submit this as a feature
request, to complement "git bisect visualize"; git, LKML or somewhere
else? I'm picturing an ncurses/menuconfig-style app.

..Stu

