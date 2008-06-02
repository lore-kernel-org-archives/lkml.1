Return-Path: <linux-kernel-owner+w=401wt.eu-S1757448AbYFBRLX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757448AbYFBRLX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2008 13:11:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753387AbYFBRLO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jun 2008 13:11:14 -0400
Received: from styx.suse.cz ([82.119.242.94]:55178 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752991AbYFBRLO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2008 13:11:14 -0400
From: Jan Kara <jack@suse.cz>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Cleanup quota header files
Date: Mon,  2 Jun 2008 19:11:05 +0200
Message-Id: <12124266712214-git-send-email-jack@suse.cz>
X-Mailer: git-send-email 1.5.2.4
In-Reply-To: y
References: y
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The series of patches below cleans up quota header files. It does several
things:
1) Rename functions from uppercase to lowercase (compatibility macros
   introduced)
2) Remove some unnecessary definitions
3) Split quota.h into two files so that we can properly declare inline
   functions.
4) Change macros to inline functions.

  So far no filesystem is converted from old function names to new ones -
that is an independent step and I'll hopefully get to that later :).
Andrew, would you merge this series?

								Honza
