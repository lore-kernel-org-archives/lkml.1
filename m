Return-Path: <linux-kernel-owner+w=401wt.eu-S1755341AbYJNXj5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755341AbYJNXj5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2008 19:39:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751930AbYJNXjp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Oct 2008 19:39:45 -0400
Received: from rv-out-0506.google.com ([209.85.198.228]:13055 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754754AbYJNXjn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2008 19:39:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=ViNeE9qhXZIBAv+yFRDFezQNLeXeViiN05edzVqw/HWrzSqE2mwXi30VpGwEJ0GtmW
         LC6I7wau7ttdQ9fClEBHEOlEAwvQRJVvCHOzSjFos1qHCeteMnPTNGz6hvwGkPL4v/+S
         lLAzDWsG52LK0qJUCs/ItDYe0XOk4RxmAaoQg=
Message-ID: <3f43f78b0810141639w4ec50a08tdc847b16ebcea5be@mail.gmail.com>
Date: Tue, 14 Oct 2008 16:39:42 -0700
From: "Kaz Kylheku" <kkylheku@gmail.com>
To: "Chris Friesen" <cfriesen@nortel.com>
Subject: Re: GPL question: using large contiguous memory in proprietary driver.
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <48F5193B.1010601@nortel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <3f43f78b0810141456r159d71e7h9763e50e7dbc0c51@mail.gmail.com>
	 <48F5193B.1010601@nortel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 14, 2008 at 3:12 PM, Chris Friesen <cfriesen@nortel.com> wrote:
> Kaz Kylheku wrote:
>
>> I have the following question. Suppose that some proprietary driver
>> (otherwise completely clean, based only on non-GPL symbols)
>
> The fact that it's not using GPL symbols does not actually mean that the
> driver is not a derivative work of the kernel (and thus subject to the GPL).

One more thing. Here is another question.

Suppose that this proprietary driver can be moved entirely into user
space. It still needs the contiguous buffer, but it can
map it using mmap, given the address.

Can this proprietary user-space application read the address
of this buffer from a custom /proc entry?

Or does this dependency make it a derived work of the kernel?
