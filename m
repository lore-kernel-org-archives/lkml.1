Return-Path: <linux-kernel-owner+w=401wt.eu-S1753986AbYAIVCM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753986AbYAIVCM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2008 16:02:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755563AbYAIVBt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jan 2008 16:01:49 -0500
Received: from fxip-0047f.externet.hu ([88.209.222.127]:56484 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755450AbYAIVBs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2008 16:01:48 -0500
To: jdike@addtoit.com
CC: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       user-mode-linux-devel@lists.sourceforge.net
Subject: uml and -regparm=3
MIME-version: 1.0
Content-type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Message-Id: <E1JCi3M-0006hO-7i@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Wed, 09 Jan 2008 22:01:36 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

FASTCALL is defined empty in -mm, but UML is not compiled with
-mregparm=3 and so this breaks things (I noticed problems with
rwsem_down_write_failed).

Tried recompiling UML with -mregparm=3, but that resulted in a strange
failure immediately after startup:

|%Gï¿½%@: Invalid argument

What's up?

Miklos
