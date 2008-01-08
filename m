Return-Path: <linux-kernel-owner+w=401wt.eu-S1755167AbYAHWkg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755167AbYAHWkg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 17:40:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752675AbYAHWk0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 17:40:26 -0500
Received: from g5t0009.atlanta.hp.com ([15.192.0.46]:47479 "EHLO
	g5t0009.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752154AbYAHWkY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 17:40:24 -0500
Message-ID: <4783FBD6.1000004@hp.com>
Date: Tue, 08 Jan 2008 14:40:22 -0800
From: Rick Jones <rick.jones2@hp.com>
User-Agent: Mozilla/5.0 (X11; U; HP-UX 9000/785; en-US; rv:1.7.13) Gecko/20060601
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: Brent Casavant <bcasavan@sgi.com>
CC: netdev@vger.kernel.org, David Miller <davem@davemloft.net>,
       linux-kernel@vger.kernel.org
Subject: Re: AF_UNIX MSG_PEEK bug?
References: <alpine.BSF.1.00.0801081556580.24286@pkunk.americas.sgi.com>
In-Reply-To: <alpine.BSF.1.00.0801081556580.24286@pkunk.americas.sgi.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Potential bugs notwithstanding, given that this is a STREAM socket, and 
as such shouldn't (I hope, or I'm eating toes for dinner again) have 
side effects like tossing the rest of a datagram, why are you using 
MSG_PEEK?  Why not simply read the N bytes of the message that will have 
the message length with a normal read/recv, and then read that many 
bytes in the next call?

rick jones
