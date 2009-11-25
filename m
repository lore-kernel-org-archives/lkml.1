Return-Path: <linux-kernel-owner+w=401wt.eu-S1758051AbZKYQQN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758051AbZKYQQN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Nov 2009 11:16:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753911AbZKYQQN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Nov 2009 11:16:13 -0500
Received: from mail-yx0-f188.google.com ([209.85.210.188]:36260 "EHLO
	mail-yx0-f188.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752557AbZKYQQM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Nov 2009 11:16:12 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=eLdkH+aFLq0a4HwbypgruJ7t0BhoGDwtjQ2jEJ+Qqd3N2pe71ztWH+p6wmr5PW5Ysr
         NG8/PZDDSpaRLwNiiirBtliMB0uMBXXjlmBd2hIpP7YyWZUJAVb943EYql4iAUl2LhcQ
         qZR/jc3MrA932Xt1YV2qJ0KQ4AJgudvORU9cU=
From: Brian Gerst <brgerst@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org,
       Tim Blechmann <tim@klingt.org>
Subject: index 780cd92..22db86a 100644
Date: Wed, 25 Nov 2009 11:16:18 -0500
Message-Id: <1259165778-3458-1-git-send-email-brgerst@gmail.com>
X-Mailer: git-send-email 1.6.5.2
In-Reply-To: <73c1f2160911250753q6c64791exabd79e994b315076@mail.gmail.com>
References: <73c1f2160911250753q6c64791exabd79e994b315076@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-	/* set up data segments. actually 0 would do too */
-	movl $__KERNEL_DS,%eax
+	/* set up data segments */
+	xorl %eax,%eax
 	movl %eax,%ds
 	movl %eax,%ss
 	movl %eax,%es
