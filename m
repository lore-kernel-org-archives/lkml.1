Return-Path: <linux-kernel-owner+w=401wt.eu-S1764935AbYEWFZ1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764935AbYEWFZ1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2008 01:25:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762052AbYEWFY6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 May 2008 01:24:58 -0400
Received: from yw-out-2324.google.com ([74.125.46.30]:65081 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763557AbYEWFY5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2008 01:24:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=W2xZT7xNCz+fUVOf1ZwmpdM0m7p/YXrA5ReI0q9rSlBpoxdFEyhnHAPeKzL4lCH68t61IQztLbdirz7M31dpPHHaxpYTBYBh6+nMLc0iD874w68wwzfSntVb0+nxBCrVnASulNHIgqnB0qB29L8bmzRTO9YwdnJms4jlmGzboE8=
Message-ID: <a36005b50805222224g79477cb2md5298bbf4e35bcfb@mail.gmail.com>
Date: Thu, 22 May 2008 22:24:56 -0700
From: "Ulrich Drepper" <drepper@gmail.com>
To: "Daniel Walker" <dwalker@mvista.com>
Subject: Re: [PATCH 3/3] futex: fix miss ordered wakeups
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <1211519720.18130.98.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080523042923.594531457@mvista.com>
	 <20080523042923.916202203@mvista.com>
	 <a36005b50805222202v6ea7b50p988eab5524935e1a@mail.gmail.com>
	 <1211519720.18130.98.camel@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 22, 2008 at 10:15 PM, Daniel Walker <dwalker@mvista.com> wrote:
> That's the problem we aren't just covering 99.99% we're trying to cover
> 100% of cases.. If we don't do it in that one case we may as well not do
> it at all.

I have no problem with removing the other ordering.  It was added
because it limited overhead.  It is completely wrong to have everybody
pay for the needs for a very small minority.
