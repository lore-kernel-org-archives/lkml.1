Return-Path: <linux-kernel-owner+w=401wt.eu-S1753159AbYI3Iuk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753159AbYI3Iuk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2008 04:50:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751939AbYI3Iud
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Sep 2008 04:50:33 -0400
Received: from fg-out-1718.google.com ([72.14.220.156]:1928 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751642AbYI3Iud convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2008 04:50:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=fkXbqdhmycbdrGjWG8dPuWkzq4b6Zjkjqh4gFUVwzWT2cXko4RFE9kJSu3M0m0KdwZ
         7dlz9OsM+Y/JeZXlX3Igk5GQw14NArNbdAMBEsOm0PClw5+ULoz3erFWA+BvYAoeSQ4v
         Edo0UeEEgX4ud+LMM7tP6XqVJJsovPnWw0T8I=
Message-ID: <c62985530809300150u16297415r160ef332a1ece2fd@mail.gmail.com>
Date: Tue, 30 Sep 2008 10:50:31 +0200
From: "=?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?=" <fweisbec@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: A style question: repeated return value check
Cc: "Pekka Paalanen" <pq@iki.fi>, linux-kernel@vger.kernel.org,
       rostedt@goodmis.org
In-Reply-To: <c62985530809300148n585327b3w8290b7761063fbd7@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
References: <48E11BFA.1070503@gmail.com>
	 <20080929221439.547d65ec@daedalus.pq.iki.fi>
	 <20080930083352.GA10374@elte.hu>
	 <c62985530809300148n585327b3w8290b7761063fbd7@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/9/30 Frédéric Weisbecker <fweisbec@gmail.com>:
> But I agree with Pekka for the fact that it could be unified in a
> single call to trace_seq_printf.
> That will produce a small "3 format" easy to understand. Seems good.

Actually it's a "5 format". Why not unify...
