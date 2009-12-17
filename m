Return-Path: <linux-kernel-owner+w=401wt.eu-S1756562AbZLQPwP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756562AbZLQPwP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Dec 2009 10:52:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751880AbZLQPwB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Dec 2009 10:52:01 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:38108 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751268AbZLQPwA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Dec 2009 10:52:00 -0500
X-Authority-Analysis: v=1.0 c=1 a=V2iCNdCPQ2YA:10 a=7U3hwN5JcxgA:10 a=VnNF1IyMAAAA:8 a=_mBC327kokF7qswlNZYA:9 a=VmjVAiv-bWdR88n0AG98SPi-N8AA:4
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Subject: Re: [PATCH 1/2] Use opaque record type in pevent accessor functions
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Darren Hart <dvhltc@us.ibm.com>
Cc: "lkml," <linux-kernel@vger.kernel.org>
In-Reply-To: <4B297C79.2090004@us.ibm.com>
References: <4B297C79.2090004@us.ibm.com>
Content-Type: text/plain; charset="ISO-8859-15"
Organization: Kihon Technologies Inc.
Date: Thu, 17 Dec 2009 10:51:57 -0500
Message-ID: <1261065117.2146.471.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-12-16 at 16:34 -0800, Darren Hart wrote:
> >From 35c283e97c16525bbebae6f9937a1ccd0f3b8da9 Mon Sep 17 00:00:00 2001
> From: Darren Hart <dvhltc@us.ibm.com>
> Date: Wed, 16 Dec 2009 15:40:31 -0800
> Subject: [PATCH 1/2] Use opaque record type in pevent accessor functions
> 
> The caller of the pevent accessor functions:
> 
> 	pevent_data_pid(pevent, data) for example
> 
> Already have a struct record. Let them send that directly:
> 
> 	pevent_data_pid(pevent, record)
> 
> This decouples the API from the struct implementation and facilitates
> language bindings which use opaque pointers for passing the C structs
> around.
> 
> Signed-off-by: Darren Hart <dvhltc@us.ibm.com>

Applied, thanks!


-- Steve


