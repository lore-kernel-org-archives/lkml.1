Return-Path: <linux-kernel-owner+w=401wt.eu-S1761098AbYBLHbh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761098AbYBLHbh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 02:31:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759523AbYBLHb1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 02:31:27 -0500
Received: from wr-out-0506.google.com ([64.233.184.227]:44931 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759512AbYBLHb1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 02:31:27 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=CQu0MsSJg4K89UFYhC6x5SweJwFe2eT8YRPfpYZQetl68Ncmt1jnNde0e73/C55Pnq6KEjefKjbVHKlqgH3fqzAr2rDyRKNxaJBerBz2SlCjXHpRh0EJ4+5XGCVTqDEh90DNP0T4ViSALboUfCcPdZsKVojkipcSZ64SDzTxZog=
Message-ID: <804dabb00802112331l60492cb4i66781a9f09d5f6c6@mail.gmail.com>
Date: Tue, 12 Feb 2008 15:31:24 +0800
From: "Peter Teoh" <htmldeveloper@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Subject: Documentation about sysfs/procfs entries (resent due to errors)
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I  was looking for documentation on the kstack_depth_to_print under
/proc/sys/kernel, and I found it in Documentation/sysctl.txt (written
by Rik).

How about /proc/sys/net?   or all other directories under /sys or /proc fs?

Wouldn't it be useful to have a centralized store located in
Documentation - properly structured,  just a one-liner or two - on the
reasons and explanations for each of these /proc or /sys parameters?
And something to look for further details?

Something of the following:

|-- netfilter
|   |-- nf_conntrack_buckets:your explanation here
|   |-- nf_conntrack_checksum:your explanation here...
|   |-- nf_conntrack_count
|   |-- nf_conntrack_expect_max
|   |-- nf_conntrack_generic_timeout
|   |-- nf_conntrack_icmp_timeout
|   |-- nf_conntrack_log_invalid
|   |-- nf_conntrack_max
|   |-- nf_conntrack_tcp_be_liberal
|   |-- nf_conntrack_tcp_loose
|   |-- nf_conntrack_tcp_max_retrans
|   |-- nf_conntrack_tcp_timeout_close
|   |-- nf_conntrack_tcp_timeout_close_wait
|   |-- nf_conntrack_tcp_timeout_established
|   |-- nf_conntrack_tcp_timeout_fin_wait
|   |-- nf_conntrack_tcp_timeout_last_ack
|   |-- nf_conntrack_tcp_timeout_max_retrans
|   |-- nf_conntrack_tcp_timeout_syn_recv
|   |-- nf_conntrack_tcp_timeout_syn_sent
|   |-- nf_conntrack_tcp_timeout_time_wait
|   |-- nf_conntrack_udp_timeout
|   `-- nf_conntrack_udp_timeout_stream
|-- nf_conntrack_max
|-- token-ring
|   `-- rif_timeout
`-- unix
    `-- max_dgram_qlen


Alternatively, we can write a script to extract out the partial
explanations/details from existing source code, based on some coding
convention/style structure, and further hand-modification from there.
 (given the dynamic nature of the kernel code, this may be preferred?)
