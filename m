Return-Path: <linux-kernel-owner+w=401wt.eu-S1755883AbYFAX1T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755883AbYFAX1T (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jun 2008 19:27:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752694AbYFAX1E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Jun 2008 19:27:04 -0400
Received: from rv-out-0506.google.com ([209.85.198.231]:24561 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752391AbYFAX1D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jun 2008 19:27:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:user-agent:date:from:to:subject;
        b=laHsKiRoNazQZn9i+jl4k6Z9cjUA28xQjsOrSnuP82/KUj5EHZMRWtquk5BdSqEyura0MGEuZhTW5fjw6mKAr7WVlHh4S7ILgkKHPFu2vHm1bf4uMfLTIdQqopL+vLAYQ+qWtQRRmdOhD6/YarHkG7TYMKGMBtCGfup6IGvoNmE=
Message-Id: <20080601231329.223608711@gmail.com>
User-Agent: quilt/0.46-1
Date: Mon, 02 Jun 2008 08:13:29 +0900
From: akinobu.mita@gmail.com
To: linux-kernel@vger.kernel.org
Subject: [patch -v2 00/23] use simple_read_from_buffer and memory_read_from_buffer
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(Apologies for resending the patches due to broken email header in
previous posting)

This series of patches is almost trivial replacement except for
introducing memory_read_from_buffer().

The only difference between memory_read_from_buffer() and
simple_read_from_buffer() is which address space the function copies to.

simple_read_from_buffer() copies to user space memory.
memory_read_from_buffer() copies to normal memory.
