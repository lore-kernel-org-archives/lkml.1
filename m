Return-Path: <linux-kernel-owner+w=401wt.eu-S1753316AbYLTN1L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753316AbYLTN1L (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Dec 2008 08:27:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751781AbYLTN1B
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Dec 2008 08:27:01 -0500
Received: from ns.yankeeboysoftware.com ([213.208.101.60]:13863 "EHLO
	smtp.yankeeboysoftware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751516AbYLTN1A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Dec 2008 08:27:00 -0500
Subject: Kernel module compiler warnings
From: Jack <gridley@yankeeboysoftware.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain
Date: Sat, 20 Dec 2008 13:26:54 +0000
Message-Id: <1229779614.1668.5.camel@prima.yankeeboysoftware.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.2 (2.24.2-2.fc10) 
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: Spam detection software, running on the system "prima.yankeeboysoftware.com", has
	identified this incoming email as possible spam.  The original message
	has been attached to this so you can view it (if it isn't spam) or label
	similar future email.  If you have any questions, see
	the administrator of that system for details.
	Content preview:  Could someone kindly explain why I see these warnings: warning:
	passing argument X of 'SOME_TYPE_HERE' discards qualifiers from pointer target
	type. I know *what* is causing the error - it's a cast removing a const [...]
	Content analysis details:   (-4.4 points, 5.0 required)
	pts rule name              description
	---- ---------------------- --------------------------------------------------
	-1.8 ALL_TRUSTED            Passed through trusted hosts only via SMTP
	-2.6 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Could someone kindly explain why I see these warnings:
 
warning: passing argument X of 'SOME_TYPE_HERE' discards qualifiers from
pointer target type.

I know *what* is causing the error - it's a cast removing a const

e.g.  


void foo(const my_type *a)
{
	bar( (my_type*)a );
}


What I don't understand is that it only seems to be emitted when I
compile on my 32 bit machine.  Compiling on my 64bit machine does not
generate this warning

Thank you,
Jack

