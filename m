Return-Path: <linux-kernel-owner+w=401wt.eu-S1757542AbYABTfZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757542AbYABTfZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2008 14:35:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753548AbYABTfP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jan 2008 14:35:15 -0500
Received: from enyo.dsw2k3.info ([195.71.86.239]:44632 "EHLO enyo.dsw2k3.info"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753022AbYABTfO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2008 14:35:14 -0500
Date: Wed, 2 Jan 2008 20:35:03 +0100
From: Matthias Schniedermeyer <ms@citd.de>
To: linux-kernel@vger.kernel.org
Subject: Why is deleting (or reading) files not counted as IO-Wait in top?
Message-ID: <20080102193503.GA31414@citd.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi


Currently i'm deleting about 500.000 files on a XFS-filesystem which 
takes a few minutes, as i had a top open i saw that 'wa' is shown as 
0.0% (Nothing else running currently) and everything except 'id' is near 
the bottom too. Kernel is 2.6.23.11.

So, as 'rm -rf' is essentially a IO (or seek, to be more correct)-bound 
task, shouldn't that count as "Waiting for IO"?

The man-page of top says:
'Amount of time the CPU has been waiting for I/O to complete.'

But AFAICT wa only seams to be (ac)counted for writing and not for 
reading. I come to that conclusion because, when i fire 'sync' i can see 
some percent wa for a few seconds.




Bis denn

-- 
Real Programmers consider "what you see is what you get" to be just as 
bad a concept in Text Editors as it is in women. No, the Real Programmer
wants a "you asked for it, you got it" text editor -- complicated, 
cryptic, powerful, unforgiving, dangerous.

