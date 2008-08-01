Return-Path: <linux-kernel-owner+w=401wt.eu-S1753850AbYHAOM5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753850AbYHAOM5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2008 10:12:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751442AbYHAOMu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Aug 2008 10:12:50 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54895 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751208AbYHAOMt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2008 10:12:49 -0400
Message-ID: <48931994.7090402@linux-foundation.org>
Date: Fri, 01 Aug 2008 09:11:32 -0500
From: Christoph Lameter <cl@linux-foundation.org>
User-Agent: Thunderbird 2.0.0.16 (Windows/20080708)
MIME-Version: 1.0
To: Reg Clemens <reg@dwf.com>
CC: =?ISO-8859-1?Q?M=E5ns_Rullg=E5rd?= <mans@mansr.com>,
       linux-kernel@vger.kernel.org, reg@fw.dwf.com
Subject: Re: Does 2.6.26 provide nanosecond time to the user?
References: <200807180019.m6I0J2kG026240@deneb.dwf.com>  <yw1x1w1srmqq.fsf@thrashbarg.mansr.com> <200807180219.m6I2J0jN002994@deneb.dwf.com>
In-Reply-To: <200807180219.m6I2J0jN002994@deneb.dwf.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Reg Clemens wrote:

> Thanks, -lrt works fine, that answers that part of the question, how about
> the first question.

The kernels use a variety of clocks internally. If the clocks are capable of
nanosecond resolution then the results will be available via clock_gettime().



