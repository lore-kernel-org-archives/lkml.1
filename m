Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752891Ab0CBRmy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Mar 2010 12:42:54 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:50935 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752244Ab0CBRmx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Mar 2010 12:42:53 -0500
X-Authority-Analysis: v=1.0 c=1 a=ehvYw00X94wA:10 a=fGO4tVQLAAAA:8 a=pVW7p-s7RKsBwdcD8VQA:9 a=bVqULK-JMNitPCpNDlznbr5MBXoA:4
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Date: Tue, 2 Mar 2010 12:42:51 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Michael Breuer <mbreuer@majjas.com>
Cc: walt <w41ter@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: Oops while booting 2.6.34-rc0 (block pull busted)
Message-ID: <20100302174250.GA13131@goodmis.org>
References: <201003011615.31709.dmitry.torokhov@gmail.com>
 <20100302075656.GO5768@kernel.dk>
 <20100302081547.GP5768@kernel.dk>
 <hmiocs$p6h$1@dough.gmane.org>
 <4B8D41C7.1030404@majjas.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B8D41C7.1030404@majjas.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 02, 2010 at 11:50:15AM -0500, Michael Breuer wrote:
> >
> >I'm getting the same oops and reverting that commit fixes it, thanks.
> >I'm happy to test patches, etc.
> >

Seems we have a winner!

I had the same bug:

http://pastebin.com/iiLgJMwy

and reverting this commit fixes it.

-- Steve

