Return-Path: <linux-kernel-owner+w=401wt.eu-S1754779AbXIQO2k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754779AbXIQO2k (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2007 10:28:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753806AbXIQO2c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Sep 2007 10:28:32 -0400
Received: from nz-out-0506.google.com ([64.233.162.232]:27334 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753692AbXIQO2b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2007 10:28:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=P0YdOPT3yIkRudyQXkURiaLhnXzVXmJFP4VjrWrM3jS5yWQrmg5daIA98yLdyWQ3SB1lSx6Nt9avWHnheS/xwaNU0Oi18rKP975ZVweBiCPPoIqpfJJ7JJYabbcLCyz3JlF2yX10idVsW5YSlS2nriiCOzLQpl5V7f5m/fSKbDc=
Message-ID: <a36005b50709170728y58aae6a4n2a570dddc2bc7720@mail.gmail.com>
Date: Mon, 17 Sep 2007 07:28:30 -0700
From: "Ulrich Drepper" <drepper@gmail.com>
To: "David Howells" <dhowells@redhat.com>
Subject: Re: Credentials test patch
Cc: viro@ftp.linux.org.uk, hch@infradead.org, torvalds@osdl.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <19877.1190026932@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1577.1189713412@redhat.com>
	 <a36005b50709150851s52d04554t62d53dab3f47eaf8@mail.gmail.com>
	 <19877.1190026932@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 9/17/07, David Howells <dhowells@redhat.com> wrote:
> A better way would be to compare fsuid/fsgid to uid/gid and to just take an
> extra ref on the incumbent cred object if they're the same, rather than always
> allocating a new one.  That, I suspect, would speed up 99.99% of the cases.

Indeed.  It's probably rare to have different values and for the case
I mentioned even more so since it happens before the first user code
gets executed.
