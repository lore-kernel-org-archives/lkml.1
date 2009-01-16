Return-Path: <linux-kernel-owner+w=401wt.eu-S1764708AbZAPTdW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764708AbZAPTdW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2009 14:33:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751658AbZAPTdJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Jan 2009 14:33:09 -0500
Received: from moutng.kundenserver.de ([212.227.17.9]:56444 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751508AbZAPTdI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2009 14:33:08 -0500
Date: 16 Jan 2009 20:32:00 +0100
From: lirc@bartelmus.de (Christoph Bartelmus)
To: linux-kernel@vger.kernel.org
Message-ID: <AtzdCwOXqgB@lirc>
Subject: get_task_comm() not exported?
User-Agent: OpenXP/4.10.7369 (Linux) (i386)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Provags-ID: V01U2FsdGVkX1/+nB2mAaOGYiMIJHFYR+f+kxVZo3NEl0Re83C
 pdewZSUocbqwLSq2yLGbB6gyFtJuVPRUGurw2cnh+aUhAriwYI
 dRne3mrX04m4jkDSOXehGg9VfZLiFlom/iNwUVil/k=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

is there any reason why get_task_comm() is not exported in fs/exec.c?

I'd like to use get_task_comm() from a kernel module and get unresolved  
symbol errors.

Adding EXPORT_SYMBOL(get_task_comm); to fs/exec.c fixes the problem.

Cheers,
Christoph

Please Cc.
