Return-Path: <linux-kernel-owner+w=401wt.eu-S932567AbYAaDVX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932567AbYAaDVX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2008 22:21:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755303AbYAaDVL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jan 2008 22:21:11 -0500
Received: from wa-out-1112.google.com ([209.85.146.177]:50178 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753841AbYAaDVI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2008 22:21:08 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=ECpNJyyXSXHBvvbXadZugza2/HoUCWvwwViDI54loah/tl75qvkjomoYEbT6hXGWdGRFk5wzQDFzG425S1WmuUeniw/NwP8UUBkdMRc+xoJQuHHdPtqLah2Kv2ycVJMuokCXUIT43hN66ezwnm9WyDowRZV2lXvXwSHh7jCi6jQ=
Message-ID: <b6a2187b0801301921s4a7842cg6cfec09a393cd63@mail.gmail.com>
Date: Thu, 31 Jan 2008 11:21:05 +0800
From: "Jeff Chua" <jeff.chua.linux@gmail.com>
To: "Patrick McHardy" <kaber@trash.net>
Subject: Re: cups slow on linux-2.6.24
Cc: "Jozsef Kadlecsik" <kadlec@blackhole.kfki.hu>,
       lkml <linux-kernel@vger.kernel.org>,
       "Krzysztof Piotr Oledzki" <ole@ans.pl>,
       "David S. Miller" <davem@davemloft.net>,
       cups-bugs <cups-bugs@easysw.com>,
       "Netfilter Development Mailinglist" <netfilter-devel@vger.kernel.org>
In-Reply-To: <47A13573.7090804@trash.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <Pine.LNX.4.64.0801290635001.23096@boston.corp.fedex.com>
	 <Pine.LNX.4.64.0801290855360.19273@blackhole.kfki.hu>
	 <b6a2187b0801291924k15f883aeg54f704156e4f2e3e@mail.gmail.com>
	 <47A07FEA.3000702@trash.net>
	 <b6a2187b0801301823m331957e9n9d9bb9613622c844@mail.gmail.com>
	 <b6a2187b0801301826l5a50ce84p7d5dce3d0a74b3c0@mail.gmail.com>
	 <47A13573.7090804@trash.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jan 31, 2008 10:41 AM, Patrick McHardy <kaber@trash.net> wrote:

> Thanks. In the dump we can see that connections reusing ports
> always have their first SYN dropped and retransmissted three
> seconds later. I'm not sure whats causing this yet, do you have
> any firewall rules that affect loopback traffic?

No firewall.

And the "lp" is just to print to a file@localhost.

# lpadmin -p lp -i /etc/cups/interfaces/lp -v lpd://localhost/file -o
printer-error-policy=retry-job
# lpadmin -p file -i /etc/cups/interfaces/file -v file:/dev/null -o
printer-error-policy=retry-job

Filter for lp is ..
  cat $6

Filter for file is ...
  cat $6 >/tmp/$$


Thanks,
Jeff.
