Return-Path: <linux-kernel-owner+w=401wt.eu-S1760056AbYFDMJd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760056AbYFDMJd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2008 08:09:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752287AbYFDMJX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jun 2008 08:09:23 -0400
Received: from py-out-1112.google.com ([64.233.166.181]:2280 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750764AbYFDMJW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2008 08:09:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:user-agent:date:from:to:subject;
        b=Lq79HHRGIjtv6XTWkpPK6Vt1iXmiknGzfPwPSxdjkrXIpCKu+FhZq+68yWgDD2Jx6m
         Fvj9L/fPPl18j/L10xGK4igOB9+UtgoihdmmrfUxslZrR2k+djZOoe8PbdGawutjAYmp
         iC4tkygTKjEzrU+synZBD5cBT+l3kaCcrOkUU=
Message-Id: <20080604115633.116832712@gmail.com>
User-Agent: quilt/0.46-1
Date: Wed, 04 Jun 2008 20:56:33 +0900
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: [patch -v3 00/22] use simple_read_from_buffer and memory_read_from_buffer
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changes since -v2:
- drop sunrpc patch because of a preference for seq_printf() conversion
- fix available buffer size in vmcp patch
- add Acked-by: from maintainers

This series of patches is almost trivial replacement except for
introducing memory_read_from_buffer().

The only difference between memory_read_from_buffer() and
simple_read_from_buffer() is which address space the function copies to.

simple_read_from_buffer() copies to user space memory.
memory_read_from_buffer() copies to normal memory.
