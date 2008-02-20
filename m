Return-Path: <linux-kernel-owner+w=401wt.eu-S932183AbYBTTqS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932183AbYBTTqS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 14:46:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758619AbYBTTpS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 14:45:18 -0500
Received: from nf-out-0910.google.com ([64.233.182.191]:60739 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756837AbYBTTpO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 14:45:14 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:user-agent:date:from:to:cc:subject;
        b=ewKCaTFAfwsd3SH1IKZ52fITWH2hNpzd+dKTYkkzcZaMS0NAdVr3Oiyn0Y1mriKyMNuERXMC3/SF5Bp2CcIWCec8mAZ7lXmw9Y+adiljuVkXUHJHu81gobQSOGoOmCKN2Zg33BhfsDdZ/qLMVnAl+4vwI/a/8v7KLPB8SQDagIM=
Message-Id: <20080220194123.114692303@gmail.com>
User-Agent: quilt/0.46-1
Date: Wed, 20 Feb 2008 22:41:23 +0300
From: gorcunov@gmail.com
To: takata@linux-m32r.org, dhowells@redhat.com, schwidefsky@de.ibm.com
Cc: sam@ravnborg.org, gorcunov@gmail.com, linux-kernel@vger.kernel.org
Subject: [patch 0/3] eliminate .data.idt section for the archs which do not use it
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series do a small clean up over vmlinux.lds script for several
architectures where the section .data.idt is not used.

Please review.
Thanks.

		- Cyrill -

-- 
