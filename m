Return-Path: <linux-kernel-owner+w=401wt.eu-S1761390AbXJFOch@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761390AbXJFOch (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Oct 2007 10:32:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755515AbXJFOc3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Oct 2007 10:32:29 -0400
Received: from rv-out-0910.google.com ([209.85.198.185]:4988 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752666AbXJFOc2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Oct 2007 10:32:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=HdY8uckexzylnnD/2MgeUTvxyIAk/CF5wF3a+JW1vHgn/XevIIfMcaGY5qne3D6bdiwB3QpXF9d23+IMpwuSY0vTNfahbarRvgeEYmIvpctOkL3TtH5Zc8D3YWyfnaSOiXNB9eSM3gUbfSEhgnPYGgtaVvaOvHFjK3BlGEbhjLI=
Message-ID: <8bd0f97a0710060732k423eec3ar8a6cdc64bcaf373@mail.gmail.com>
Date: Sat, 6 Oct 2007 10:32:27 -0400
From: "Mike Frysinger" <vapier.adi@gmail.com>
To: "Robert P. J. Day" <rpjday@mindspring.com>
Subject: Re: apparently missing include/linux header files
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0710060544270.2942@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <Pine.LNX.4.64.0710060544270.2942@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/6/07, Robert P. J. Day <rpjday@mindspring.com> wrote:
>   the result of running a quick and dirty shell script that locates
> inclusions of header files under "include/linux" where those header
> files don't appear to exist.  (i didn't look any more closely at the
> results and, apparently, these missing header files aren't fatal since
> the builds still work but it's just FYI.)

the ones related to kgdb are "normal" ... they require the kgdb patch
to be applied and if it isnt, then it isnt possible to build the files
in question
-mike
