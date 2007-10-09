Return-Path: <linux-kernel-owner+w=401wt.eu-S1754945AbXJIG5W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754945AbXJIG5W (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2007 02:57:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752089AbXJIG5O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Oct 2007 02:57:14 -0400
Received: from smtp-out001.kontent.com ([81.88.40.215]:38326 "EHLO
	smtp-out001.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751964AbXJIG5N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2007 02:57:13 -0400
From: Oliver Neukum <oliver@neukum.org>
To: Pavel Machek <pavel@ucw.cz>
Subject: Re: gigabit ethernet power consumption
Date: Tue, 9 Oct 2007 08:58:46 +0200
User-Agent: KMail/1.9.6 (enterprise 20070731.694771)
Cc: Arjan van de Ven <arjan@infradead.org>,
       kernel list <linux-kernel@vger.kernel.org>
References: <20071008220720.GF3484@elf.ucw.cz>
In-Reply-To: <20071008220720.GF3484@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710090858.46760.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Am Dienstag 09 Oktober 2007 schrieb Pavel Machek:
> Question is, how to implement it correctly? Daemon that would watch
> data rates and switch speeds using mii-tool would be simple, but is
> that enough?

Do you only want to affect true ethernet devices this way? It seems
to me that the savings for wireless devices could be larger and we don't
want a separate mechanism for each type of network device. So I think
you need to tell the kernel why you want to reduce the link speed.

	Regards
		Oliver

