Return-Path: <linux-kernel-owner+w=401wt.eu-S1756262AbYDJCnt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756262AbYDJCnt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2008 22:43:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753685AbYDJCnm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Apr 2008 22:43:42 -0400
Received: from smtp-out.google.com ([216.239.33.17]:58312 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753293AbYDJCnl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2008 22:43:41 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=sfj8HTdIsSyqoDJVq1I/54c4SZLrbZMFvQAzFnpu3ZtuoW7+sPQaqjtEvE4tvTpUs
	1YzIY9EBEtlJFMukEq/aA==
Message-ID: <6599ad830804091943j1f8a4500w5eda7774adfba69f@mail.gmail.com>
Date: Wed, 9 Apr 2008 19:43:30 -0700
From: "Paul Menage" <menage@google.com>
To: sukadev@us.ibm.com
Subject: Re: [PATCH 0/3] clone64() and unshare64() system calls
Cc: "H. Peter Anvin" <hpa@zytor.com>, "Andrew Morton" <akpm@osdl.org>,
       clg@fr.ibm.com, serue@us.ibm.com,
       "David C. Hansen" <haveblue@us.ibm.com>,
       "Pavel Emelyanov" <xemul@openvz.org>,
       Containers <containers@lists.osdl.org>, linux-kernel@vger.kernel.org
In-Reply-To: <20080410023818.GD28477@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080409222611.GA28087@us.ibm.com> <47FD5899.2040206@zytor.com>
	 <20080410010717.GA28477@us.ibm.com> <47FD6921.6090408@zytor.com>
	 <20080410023818.GD28477@us.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 9, 2008 at 7:38 PM,  <sukadev@us.ibm.com> wrote:
>
>  But as Jon Corbet pointed out in the the thread above, it looked like
>  adding a new system call has been the "traditional" way of solving this
>  in Linux so far and there has been no consensus on a newer approach.
>

I thought that the consensus was that adding a new system call was
better than trying to force extensibility on to the existing
non-extensible system call.

But if we are adding a new system call, why not make the new one
extensible to reduce the need for yet another new call in the future?

Paul
