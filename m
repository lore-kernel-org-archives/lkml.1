Return-Path: <linux-kernel-owner+w=401wt.eu-S1753484AbYKXTK5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753484AbYKXTK5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2008 14:10:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752191AbYKXTKt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Nov 2008 14:10:49 -0500
Received: from qw-out-2122.google.com ([74.125.92.24]:63729 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751904AbYKXTKs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2008 14:10:48 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=o0Q7Ys/sYOCY6TWdaAGvQhCOLIZ+6Y+SCV7ftQ2mdhWtkDyTvPnYWputbDD3lN9cw4
         fOdujrSVCYTjo7Xz6izc636gMiLXU26OAGNHY5xyJYR4Q4cTEy/icy8t/Q0ugE+7A7rr
         0o1C89xhQz3wR5BlOCdMx9+6C49SUGu2nnmoI=
Message-ID: <c62985530811241110o32a601ddud0cfc02a9767a7d8@mail.gmail.com>
Date: Mon, 24 Nov 2008 20:10:47 +0100
From: "=?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?=" <fweisbec@gmail.com>
To: "Arnaldo Carvalho de Melo" <acme@redhat.com>,
       "=?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?=" <fweisbec@gmail.com>,
       "Ingo Molnar" <mingo@elte.hu>, "Steven Rostedt" <rostedt@goodmis.org>,
       "Linux Kernel" <linux-kernel@vger.kernel.org>
Subject: Re: Human readable output for function return tracer
In-Reply-To: <20081124181515.GG26466@ghostprotocols.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <c62985530811240639w574659c0nd0a54e6c1fb1197a@mail.gmail.com>
	 <20081124181515.GG26466@ghostprotocols.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/11/24 Arnaldo Carvalho de Melo <acme@redhat.com>:
> I do something like that in my ctracer tool[1], take a look at one of
> the callgraphs:
>
> http://oops.ghostprotocols.net:81/ostra/dccp/tx/


Oh yes, that's what I would see as an end result. Except that it would be more
easy for me to have the time of execution on the left (I don't need the time
they are called since it's just a cost measure).


> I.e. the leaf functions doesn't use {}

I guess I could avoid it too..


> On ctracer I didn't had this problem as I don't trace all functions,
> just the ones that receive as one of its parameters a pointer to the
> desired struct, and this pointer is present in all the trace buffer
> entries,

How do you do this tracing by only passing a structure?

> so as part of postprocessing it separates the callgraphs per
> object.

I would like to separate the callgraph per thread. I'm not sure how. Perhaps
by only drawing a simple

------8<----- switch to task nr x -----------8<-------------------
