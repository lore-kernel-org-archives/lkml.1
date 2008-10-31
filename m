Return-Path: <linux-kernel-owner+w=401wt.eu-S1751883AbYJaQyj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751883AbYJaQyj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2008 12:54:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751735AbYJaQya
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Oct 2008 12:54:30 -0400
Received: from nf-out-0910.google.com ([64.233.182.186]:63898 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751479AbYJaQy3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2008 12:54:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=vXhxOMW/6/mc21dHu5o1hWLoWbPdthP4/g4+1AH732eoQRSrlS/gdY9kNJULx5CF+H
         jNozcnwqsqkkvf3ih36lg5S/+LFmVDFInU2ir9uaIJiChB4w51aSbjbM/3ZAv4SdOnYe
         sKzIxtwPPnb6jh8CvHxM4rjE3LcYj6EEepU08=
Date: Fri, 31 Oct 2008 19:57:51 +0300
From: Alexey Dobriyan <adobriyan@gmail.com>
To: mingo@elte.hu
Cc: linux-kernel@vger.kernel.org
Subject: alpha: undefined reference to `save_stack_trace'
Message-ID: <20081031165751.GA13558@x200.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On alpha-smp-[ny]-debug-y:

  LD      .tmp_vmlinux1
kernel/built-in.o: In function `ftrace_trace_stack':
(.text+0x706fc): undefined reference to `save_stack_trace'


Somehow STACKTRACE is set despite no STACKTRACE_SUPPORT.
