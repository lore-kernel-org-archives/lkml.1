Return-Path: <linux-kernel-owner+w=401wt.eu-S1755219AbYKCNcd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755219AbYKCNcd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2008 08:32:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755292AbYKCNcN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Nov 2008 08:32:13 -0500
Received: from qw-out-2122.google.com ([74.125.92.26]:55525 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755260AbYKCNcM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2008 08:32:12 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=NXD00iamzeeujEEBxlrMzn5RKRL6+1qXT21xc8rotIsceOxHzY4WM32hADjS3SP3vU
         AMrKsnT6nKV4MdY5IJMlpHzfC/WouhglEk5rsI0ncrj2KUvX678KAUlpvoOSJvfGnyf9
         LsiRvPtH+9G2O187sRn//GZx9Qf2mO+YEdyQg=
Message-ID: <c62985530811030532i70d3320ahd51bf829fc6fa97a@mail.gmail.com>
Date: Mon, 3 Nov 2008 14:32:10 +0100
From: "=?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?=" <fweisbec@gmail.com>
To: ananth@in.ibm.com
Subject: Re: [RFC][PATCH] Make ftrace able to trace function return
Cc: "Ingo Molnar" <mingo@elte.hu>, "Steven Rostedt" <rostedt@goodmis.org>,
       =?iso-8859-1?Q?Fr=E9d=E9ric_Weisbecker_=3Cfweisbec=40gmail=2Ecom=3E?=@thinktux.in.ibm.com,
       linux-kernel@vger.kernel.org, "Jim Keniston" <jkenisto@us.ibm.com>
In-Reply-To: <20081103111602.GA7515@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <490A08E3.2040201@gmail.com> <20081030182056.GA14102@elte.hu>
	 <c62985530810301130q41cc5c0ete2d7610d2172775@mail.gmail.com>
	 <20081030183714.GA17822@elte.hu>
	 <alpine.DEB.1.10.0810301447490.15853@gandalf.stny.rr.com>
	 <20081030192621.GF27407@elte.hu> <20081103111602.GA7515@in.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/11/3 Ananth N Mavinakayanahalli <ananth@in.ibm.com>:
> There were other issues encountered during its implementation (some
> of them 'cos we hash instances on the task) were with routines that are
> entered/exited in different task contexts, noret type functions, etc.

I think I have some problems related to noret type functions too.
That's interesting, I will read your implementation....
