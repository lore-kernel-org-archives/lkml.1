Return-Path: <linux-kernel-owner+w=401wt.eu-S1754128Ab0ALQNq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754128Ab0ALQNq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jan 2010 11:13:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751448Ab0ALQNp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jan 2010 11:13:45 -0500
Received: from cluster-d.mailcontrol.com ([85.115.60.190]:39034 "EHLO
	cluster-d.mailcontrol.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932065Ab0ALQNo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jan 2010 11:13:44 -0500
Message-ID: <4B4C9ED9.60905@csr.com>
Date: Tue, 12 Jan 2010 16:10:01 +0000
From: David Vrabel <david.vrabel@csr.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: =?UTF-8?B?TsOpbWV0aCBNw6FydG9u?= <nm127@freemail.hu>
CC: linux-usb@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       Julia Lawall <julia@diku.dk>, cocci@diku.dk
Subject: Re: [PATCH] uwb: make USB device id constant
References: <4B4C297A.5090405@freemail.hu>
In-Reply-To: <4B4C297A.5090405@freemail.hu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 12 Jan 2010 16:10:01.0926 (UTC) FILETIME=[B2065E60:01CA93A1]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Németh Márton wrote:
> From: Márton Németh <nm127@freemail.hu>
> 
> The id_table field of the struct usb_device_id is constant in <linux/usb.h>
> so it is worth to make the initialization data also constant.

Thanks.

> The semantic match that finds this kind of pattern is as follows:
> (http://coccinelle.lip6.fr/)

Can you please not include this as part of the changelog in future?  You
may include it after the '---' if you wish.

David
-- 
David Vrabel, Senior Software Engineer, Drivers
CSR, Churchill House, Cambridge Business Park,  Tel: +44 (0)1223 692562
Cowley Road, Cambridge, CB4 0WZ                 http://www.csr.com/


Member of the CSR plc group of companies. CSR plc registered in England and Wales, registered number 4187346, registered office Churchill House, Cambridge Business Park, Cowley Road, Cambridge, CB4 0WZ, United Kingdom
