Return-Path: <linux-kernel-owner+w=401wt.eu-S1758621AbYJILot@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758621AbYJILot (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2008 07:44:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756615AbYJILol
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Oct 2008 07:44:41 -0400
Received: from ey-out-2122.google.com ([74.125.78.27]:38176 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756356AbYJILok (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2008 07:44:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=u+S8HqDcdcd4dR3UeanaHQlZI6wqz/88Tp+G9VgugEKK773DCQtVUga1lu+8Bb2id3
         MSBRsyQMJKxEQUxE85qF0SIBNVl8pn6cPZdeVWurKhgPsU1hwIkmHY3aX0dhGBSWCzko
         BEdQXkp8RbLO2yK3M6qoQB7yLEXd7bribS+Qo=
Message-ID: <c62985530810090444k4ee22a45p94d3b61670259d5d@mail.gmail.com>
Date: Thu, 9 Oct 2008 13:44:38 +0200
From: "=?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?=" <fweisbec@gmail.com>
To: "Andi Kleen" <andi@firstfloor.org>
Subject: Re: [PATCH] rudimentary tracing for Classic RCU
Cc: paulmck@linux.vnet.ibm.com, linux-kernel@vger.kernel.org, mingo@elte.hu,
       rjw@sisk.pl, dipankar@in.ibm.com, tglx@linuxtronix.de
In-Reply-To: <20081009105305.GF24560@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20081006232837.GA1157@basil.nowhere.org>
	 <20081007071544.GC20740@one.firstfloor.org>
	 <20081007152629.GH6384@linux.vnet.ibm.com>
	 <20081007154939.GN20740@one.firstfloor.org>
	 <20081007163401.GJ6384@linux.vnet.ibm.com>
	 <20081007210947.GP20740@one.firstfloor.org>
	 <20081007212215.GN6384@linux.vnet.ibm.com>
	 <20081009010846.GA10188@linux.vnet.ibm.com>
	 <c62985530810090323vd5d08e0haa618ca0cbe0c73f@mail.gmail.com>
	 <20081009105305.GF24560@one.firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/10/9 Andi Kleen <andi@firstfloor.org>:
>> Why don't you use the ring-buffer tracing engine?
>
> Because he doesn't actually need a ring buffer, it's a snapshot in
> time.

You have the possibility to implement a read callback to not use the
ring buffer.

> ftrace-of-bork wants to assimilate everything?

I just proposed that to unify the tracers.
