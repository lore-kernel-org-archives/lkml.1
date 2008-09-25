Return-Path: <linux-kernel-owner+w=401wt.eu-S1755157AbYIYQlI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755157AbYIYQlI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2008 12:41:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752844AbYIYQkz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Sep 2008 12:40:55 -0400
Received: from fk-out-0910.google.com ([209.85.128.191]:37613 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752658AbYIYQkz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2008 12:40:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=Zvh6bPTOOVj4QQKtPEvbezsQEu43VA4V6xEBnBQsL7j6HW2WIsTyi2a3V94zeoRm7S
         ubHKSv1bOvZxD/GliIvWMiYySyoZi7MSS8NezXdXadvak7WxyIb1gzqxJyECpa5fbPEe
         E8+b4LR76tEPsfQBejG833PoBtm6Dvp2TU5j4=
Message-ID: <c62985530809250940s1cdab6dau87bee24b6bc6c089@mail.gmail.com>
Date: Thu, 25 Sep 2008 18:40:53 +0200
From: "=?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?=" <fweisbec@gmail.com>
To: "Pekka Paalanen" <pq@iki.fi>
Subject: Re: [Patch -tip 1/3] Tracing/ftrace: Relay unhandled entry output
Cc: "Steven Rostedt" <rostedt@goodmis.org>, "Ingo Molnar" <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
In-Reply-To: <20080925190149.208ee3a4@daedalus.pq.iki.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <48DB81BA.2050204@gmail.com> <20080925123802.GA6900@elte.hu>
	 <48DBA683.8000708@gmail.com>
	 <20080925180916.75d3c9ec@daedalus.pq.iki.fi>
	 <c62985530809250833x2468f07an547a82eaa1329d9@mail.gmail.com>
	 <20080925184919.016d8957@daedalus.pq.iki.fi>
	 <c62985530809250856l2c4e827cv2123b6c3c21210d7@mail.gmail.com>
	 <20080925190149.208ee3a4@daedalus.pq.iki.fi>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/9/25 Pekka Paalanen <pq@iki.fi>:
> Oh cool, sounds like I should try linux-next when I can.


It is on -tip if you want :)

So, unless someone is opposed to. I will send a patch which define
three possible values
for the print_line callback. I will define these values on trace.h
Why not:

#define TRACE_TYPE_PARTIAL_LINE 0
#define TRACE_TYPE_HANDLED 1
#define TRACE_TYPE_UNHANDLED 2   => will relay on default functions

Hmm I'm questionning about the relevance of this kind of patch since
the tracing API is in refactoring...
