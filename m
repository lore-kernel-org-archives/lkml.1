Return-Path: <linux-kernel-owner+w=401wt.eu-S1752559AbYCMMZW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752559AbYCMMZW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2008 08:25:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752922AbYCMMZJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Mar 2008 08:25:09 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:40351 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752519AbYCMMZI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2008 08:25:08 -0400
To: linux-kernel@vger.kernel.org
CC: linux-fsdevel@vger.kernel.org, containers@lists.linux-foundation.org,
       jean-pierre.andre@wanadoo.fr
Subject: accessing "nonexistent" /proc/<tid>/
Message-Id: <E1JZmUX-000882-F9@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Thu, 13 Mar 2008 13:25:01 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jean-Pierre noticed, that it's possible to access any task through
/proc/<tid>/, not just the thread group leader.

Is this intentional?  I can't find it documented anywhere, but it's
definitely a useful feature.  So maybe it's worth making it officially
part of the kernel interface, and adding a note to
Documentation/filesystems/proc.txt?

Miklos
