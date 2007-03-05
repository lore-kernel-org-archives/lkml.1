Return-Path: <linux-kernel-owner+w=401wt.eu-S1752794AbXCEQ32@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752794AbXCEQ32 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2007 11:29:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752791AbXCEQ32
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Mar 2007 11:29:28 -0500
Received: from mx2.bluearc.com ([62.190.48.221]:2790 "EHLO
	uk-msw.terastack.bluearc.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752780AbXCEQ31 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2007 11:29:27 -0500
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: Nfs over tcp retries
Date: Mon, 5 Mar 2007 16:29:25 -0000
Message-ID: <0F10A59FDFFDFD4E9BEBD7365DE672559C65BC@uk-email.terastack.bluearc.com>
In-Reply-To: <1173111188.6470.26.camel@heimdal.trondhjem.org>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: Nfs over tcp retries
Thread-Index: AcdfQTdRHFQn9TwFSjaKRdm5aakWGQAASbjw
References: <0F10A59FDFFDFD4E9BEBD7365DE672559C654F@uk-email.terastack.bluearc.com> <1173111188.6470.26.camel@heimdal.trondhjem.org>
From: "Andy Chittenden" <andyc@bluearc.com>
To: "Trond Myklebust" <trond.myklebust@fys.uio.no>
Cc: <linux-kernel@vger.kernel.org>,
       "Mr. Charles Edward Lever" <Chuck.Lever@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Why is the server disconnecting from the client in the first 
> place? That
> seems odd...

To cut a long story short, it comes down to a resource issue: the server
decided to sever ties with the client as it knew the client would
reconnect if it needed to.

> Servers commonly implement duplicate request caches that depend on a
> combination of the XID, port number RPC program number and 
> RPC procedure
> number (See http://www.connectathon.org/talks96/werme1.html). In order
> for that to work, the clients have to obey the convention that they
> reuse port numbers as well as XIDs when replaying a request.

Thanks. Since I sent the original message, I'd stumbled upon this thread
too that suggested that:
<http://lists.freebsd.org/pipermail/freebsd-fs/2005-October/001417.html>
.

We're currently looking into what Solaris does.

Thanks again for your help.

-- 
Andy, BlueArc Engineering
