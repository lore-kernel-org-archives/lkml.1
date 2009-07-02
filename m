Return-Path: <linux-kernel-owner+w=401wt.eu-S1752234AbZGBHgs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752234AbZGBHgs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jul 2009 03:36:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751183AbZGBHgj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Jul 2009 03:36:39 -0400
Received: from mail-qy0-f193.google.com ([209.85.221.193]:42282 "EHLO
	mail-qy0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751059AbZGBHgj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jul 2009 03:36:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=vY9yO57p8cUg/HNkvh6MCrAOcVhGgfLG+YKiV5btj7Mg1Sn8OCvgxNwHkx39KjEA9a
         Hz+4ViwY5rsIfq0nNWauIUUCBiDMCJLWlbAHlqD1G2paz/kd+rCzmj8axK2FxGNzLRVX
         fEnH/G99Z1VKClHBEiOawZEL5N+P6H0bkCD2E=
MIME-Version: 1.0
Date: Thu, 2 Jul 2009 15:36:41 +0800
Message-ID: <412e6f7f0907020036y76abbc7du99c7b695f725be4@mail.gmail.com>
Subject: PROPOSAL: extend pipe() to support NULL argument.
From: Changli Gao <xiaosuo@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linux also uses pipes as references of kernel buffers. In that case,
only one RW file descriptor will be enough, instead of inventing a new
system call, I think extending the existing pipe() is a better idea.
If pipe is passed with a NULL pointer, one RW file descriptor is
returned. I have checkd the other architectures except of x86, it
seems that not all of the platforms implement this system call with
the prototype: int pipe(int fd[2]); and changing glibc is needed. Is
it possible to extend pipe() in this way?

-- 
Regards，
Changli Gao(xiaosuo@gmail.com)
