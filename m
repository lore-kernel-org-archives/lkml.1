Return-Path: <linux-kernel-owner+w=401wt.eu-S1755284AbZG1Vaq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755284AbZG1Vaq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 17:30:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754496AbZG1Vap
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 17:30:45 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:43543 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753306AbZG1Vap (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 17:30:45 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Lee Howard <faxguy@howardsilvan.com>
Subject: Re: [Fwd: how to debug: BUG: soft lockup - CPU#3 stuck for 61s!]
Date: Tue, 28 Jul 2009 23:30:52 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.31-rc4-rjw; KDE/4.2.4; x86_64; ; )
Cc: linux-kernel@vger.kernel.org
References: <4A6F67E3.60201@howardsilvan.com>
In-Reply-To: <4A6F67E3.60201@howardsilvan.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200907282330.53059.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 28 July 2009, Lee Howard wrote:
> I installed Fedora 11 and I'm getting the same thing there, too (kernel
> 2.6.29.6-213.fc11.x86_64).
> 
> What can I do to help fix this?

Please test the last 2.6.30.y from kernel.org.  If the bug is still there, test
2.6.31-rc4 or later.  If the bug is still there, please report it here or at
bugzilla.kernel.org.

If the bug is not present in 2.6.30.y, try to find the commit that fixed it
(using git-bisect, but marking good commits as 'bad' and bad commits as 'good')
and point the Fedora kernel maintainer(s) to it.  Same for 2.6.31-rc4 or later.

Best,
Rafael
