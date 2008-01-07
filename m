Return-Path: <linux-kernel-owner+w=401wt.eu-S1756419AbYAGPpR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756419AbYAGPpR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2008 10:45:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751489AbYAGPpG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jan 2008 10:45:06 -0500
Received: from smtp.seznam.cz ([77.75.72.43]:47310 "HELO smtp.seznam.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751761AbYAGPpE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2008 10:45:04 -0500
From: "Frantisek Rysanek" <Frantisek.Rysanek@post.cz>
To: "=?ISO-8859-2?Q?J=F6rn_Engel?=" <joern@logfs.org>,
       linux-kernel@vger.kernel.org
Date: Mon, 07 Jan 2008 16:51:22 +0100
MIME-Version: 1.0
Subject: Re: [noob q. on block layer] block IO read-ahead during sequential *write*?
Message-ID: <4782588A.3856.1B9C57D9@localhost>
In-reply-to: <20080107124952.GA8201@lazybastard.org>
References: <47822835.4182.1ADF8AE7@localhost>
X-mailer: Pegasus Mail for Windows (4.21c)
Content-type: text/plain; charset=ISO-8859-2
Content-transfer-encoding: 8BIT
Content-description: Mail message body
X-Smtpd: 1.0.26@12465M
X-Seznam-User: frantisek.rysanek@post.cz
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 7 Jan 2008 at 13:49, Jörn Engel wrote:
>
> If you retry the dd with bs=4096 (or whatever your architecture's page
> size happens to be), does this still occur?
> 
> JÃ¶rn
> 
wow, thanks, it works, this is so obvious.
I tend to use values like bs=512000 or suchlike, but probably never
stroke this particular value when I was looking at iostat.
Must've missed that modulo 4096 somehow.

Seems like cp is using 512B per transaction, judging by how slow the
transfer goes. If I use bs=500000 or even bs=1024, it goes faster.

Have a nice day :-}

Frank Rysanek
