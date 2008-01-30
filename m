Return-Path: <linux-kernel-owner+w=401wt.eu-S1755203AbYA3FT7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755203AbYA3FT7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2008 00:19:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751391AbYA3FTv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jan 2008 00:19:51 -0500
Received: from fg-out-1718.google.com ([72.14.220.157]:40523 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750850AbYA3FTu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2008 00:19:50 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=qNksAD/DCpOmbXghKjSTCC4qZm/s5620X42RrKX82+irYnJVyJzeQNABBNtYGRrNfA0KA6q8bfSDOKoWgx9FMRxmvViipOXdOh9O1PDZvcfFcDOM3f9ORRJOwgBk8BZG7VYeYehZUoYBM1RQtmduUqCvFC59/IBhVLfKizXuC9E=
Message-ID: <fd0955ee0801292119l1859a04aic07b23c59c5359a@mail.gmail.com>
Date: Wed, 30 Jan 2008 10:49:49 +0530
From: "PV Juliet" <pvjuliet@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Change In sk_buff structure in 2.6.22 kernel
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi All,


The header fields in the sk_buff structure have been renamed and are
no longer unions.

Networking code and drivers are supposed to use skb->transport_header,
skb->network_header, and skb->skb_mac_header.
But when I am trying to access fields of TCP using the code
struct tcphdr *tcp = skb->transport_header;
tcp->   //accessing proper field
It is not accessing the value properly ...
Can anyone please help me ???


Thanks in advance
Regards
Juliet
