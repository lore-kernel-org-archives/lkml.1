Return-Path: <linux-kernel-owner+w=401wt.eu-S1763181AbXKOPA1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763181AbXKOPA1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2007 10:00:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758225AbXKOPAQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Nov 2007 10:00:16 -0500
Received: from wa-out-1112.google.com ([209.85.146.178]:15638 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757288AbXKOPAO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2007 10:00:14 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=V01YLlT9t4059sBy2Tu1K14CDDQCB8LR9QIgwdPKhEXJGrLDugOjnYq9uiqdrqLeL004Ow7+eOFmznDTAOY64FmWfjVcAdRHbOVFQZB3RKBfRrq3uPPkwbZ5kkBtO9Z9xopun7C6qj9UHBATOR6zWCLRwfwzI9DUw5H0cnqf1W4=
Message-ID: <863e9df20711150700i3c84374ava108f5b585e8498b@mail.gmail.com>
Date: Thu, 15 Nov 2007 20:30:13 +0530
From: "Abhishek Sagar" <sagar.abhishek@gmail.com>
To: "Jim Keniston" <jkenisto@us.ibm.com>
Subject: Re: [PATCH][RFC] kprobes: Add user entry-handler in kretprobes
Cc: "Srinivasa Ds" <srinivasa@in.ibm.com>, linux-kernel@vger.kernel.org,
       prasanna@in.ibm.com, davem@davemloft.net,
       anil.s.keshavamurthy@intel.com,
       "Ananth N Mavinakayanahalli" <ananth@in.ibm.com>
In-Reply-To: <1195080664.5781.78.camel@dyn9047018096.beaverton.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <47389BEB.1000901@gmail.com>
	 <863e9df20711121039t5352a993xc9eeb6bfea123805@mail.gmail.com>
	 <863e9df20711130247g45d3d541j10c76434e9c65b00@mail.gmail.com>
	 <473AAA75.2050900@in.ibm.com>
	 <863e9df20711140049q3ad486ben7ace2edab0a2ca41@mail.gmail.com>
	 <473ACCBE.9010308@in.ibm.com>
	 <863e9df20711140530h69df9107g38e293aab278686a@mail.gmail.com>
	 <1195080664.5781.78.camel@dyn9047018096.beaverton.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Nov 15, 2007 4:21 AM, Jim Keniston <jkenisto@us.ibm.com> wrote:
> 2. Simplify the task of correlating data (e.g., timestamps) between
> function entry and function return.

Would adding of data and len fields in ri help? Instead of "pouching"
data in one go at registration time, this would let user handlers do
the allocation and allow them to use different kinds of data
structures per-instance.

- Abhishek Sagar
