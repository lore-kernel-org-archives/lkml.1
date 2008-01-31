Return-Path: <linux-kernel-owner+w=401wt.eu-S1764536AbYAaHHG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764536AbYAaHHG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2008 02:07:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753670AbYAaHGy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jan 2008 02:06:54 -0500
Received: from rv-out-0910.google.com ([209.85.198.186]:5972 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753651AbYAaHGx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2008 02:06:53 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=XKsAbJnF+vfXxKp6EKd2+6zUtIoFmdHU0nu6zIZbf0ZqBYU77WL9/0xhsm8chzW3jKgDraNKRJ8J/3G9KkPD8wZOQoyXNGYJhHG6+UpZ2lYbhzuSVOlq/qiH8pO8QsIE6DdtvMrv2HqRKGWVQvjR9xKLvkHRxRFbGnvWVGPRxH0=
Message-ID: <86802c440801302306g2a1ae11h52b883eed79b7e96@mail.gmail.com>
Date: Wed, 30 Jan 2008 23:06:53 -0800
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>, "Andi Kleen" <ak@suse.de>
Subject: Re: system without RAM on node0 boot fail
Cc: "Christoph Lameter" <clameter@sgi.com>, "Ingo Molnar" <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
In-Reply-To: <47A16616.9070606@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200801302026.27130.yinghai.lu@sun.com>
	 <200801302102.09510.yinghai.lu@sun.com>
	 <Pine.LNX.4.64.0801302049180.15109@schroedinger.engr.sgi.com>
	 <47A16616.9070606@zytor.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jan 30, 2008 10:09 PM, H. Peter Anvin <hpa@zytor.com> wrote:
> Christoph Lameter wrote:
> > x86 supports booting from a node without RAM?

it is a two sockets system. only 4G RAM installed on node1.

>
>  From the looks of it I would say he probably has the boot node numbered 1.
>
> The e820 map is also "interesting" - doesn't list the first 256 bytes,
> which corresponds to the first quarter(!) of the real-mode exception table.

i kexec that from 2.6.24 (with discontinuous and slab)
so that e820 is passed by kexec from first kernel. normal pxeboot will
have start for 0.

YH
