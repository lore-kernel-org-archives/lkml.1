Return-Path: <linux-kernel-owner+w=401wt.eu-S1030841AbXCNJx0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030841AbXCNJx0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2007 05:53:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030835AbXCNJx0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Mar 2007 05:53:26 -0400
Received: from ag-out-0708.google.com ([72.14.246.243]:39634 "EHLO
	ag-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030841AbXCNJxZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2007 05:53:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=XWbGfb/McVd7ItJhafkU1fS3L8L/LyTptw6n3w6rgQJytMICWHO0udlVcYrLFfAwZLU4RZJ5Z1eo91LW9I+S6vm3Vui1uqOfsk0m7VYmgFhdBReecPpaFRIRzVoVsvONDOzUkA9RSyp9a6ubT7RV5cAsElnqxvQB3080wrCI0gY=
Message-ID: <77e1146f0703140253h217a5cfdk94956882bedf5a1e@mail.gmail.com>
Date: Wed, 14 Mar 2007 15:23:24 +0530
From: "sujay g" <mail.sujayg@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: fib search and handling
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I am newbie developing a routing application which
needs three features;

1. if the fib lookup fails, my application needs to know about using
preferably
netlink, -- any direction to some sample code or files in the kernel???

2. I need a counter recording the hits a fib entry is chosen for
packet forwarding. Is it the function fn_trie_lookup in file
/net/ipv4/fib_trie.c i need to modify and look into?
-- ?? and therefore is it safe to add a int counter in fib_node w/o
breaking the build??

2. need to read the entire fib, i.e dump the fib to the user space,
-- again any direction to some sample code etc..
i have seen a fn in /source/net/ipv4/fib_frontend.c , which looks like
is supposed to dump the routes but not sure how to use it..

line no.581 int inet_dump_fib(struct sk_buff *skb, struct
netlink_callback *cb)
Also;
fn_trie_dump() in /net/ipv4/fib_trie.c


This could be an inappropriate list for the above questions,  if it is
request for
some direction on the appropriate mailing list

Appreciate any help.

Thanking you,
Sujay
