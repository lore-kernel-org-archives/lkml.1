Return-Path: <linux-kernel-owner+w=401wt.eu-S1752691AbYATJrK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752691AbYATJrK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jan 2008 04:47:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751363AbYATJrA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Jan 2008 04:47:00 -0500
Received: from ozlabs.org ([203.10.76.45]:53896 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751221AbYATJq7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jan 2008 04:46:59 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 0/6] RFC: Typesafe callbacks
Date: Sun, 20 Jan 2008 20:46:13 +1100
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Jeff Garzik <jeff@garzik.org>, Tejun Heo <htejun@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801202046.14746.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

   Converting to and from void * for callback functions loses type safety: 
everywhere else we expect the compiler to catch incorrect pointer types 
handed to functions.

   It's pretty simple to create typesafe callback functions using typeof, and 
with a little gcc trickery we can allow both old-style and typesafe callbacks 
to avoid churn on commonly-used routines.

Feedback welcomed,
Rusty.
