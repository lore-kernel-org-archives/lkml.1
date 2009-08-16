Return-Path: <linux-kernel-owner+w=401wt.eu-S1755925AbZHPUKO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755925AbZHPUKO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Aug 2009 16:10:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755523AbZHPUKN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Aug 2009 16:10:13 -0400
Received: from an-out-0708.google.com ([209.85.132.245]:47122 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754753AbZHPUKM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Aug 2009 16:10:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=AY7elF20qOxujFlEILalMdGUIob7gA50mE2YpW9AXyj9cKrF7yaOCKytgdGC4mbNeN
         vpUUe/xwRsvST9lagdHDTqOnZVhZO7WRlloLPk3amxXtplkZwCipiJSkEETajWhI3uvm
         LxiEcOlu2Tu6Ln2uoXko1TsrF5J4xXymtFnPc=
MIME-Version: 1.0
In-Reply-To: <4A885FD1.4030105@gmail.com>
References: <1250002683-28554-1-git-send-email-mspang@csclub.uwaterloo.ca>
	 <4A87FCAC.5070705@gmail.com>
	 <118a63b80908160642j73568637n2f3fa97fc33d8e57@mail.gmail.com>
	 <4A885FD1.4030105@gmail.com>
Date: Sun, 16 Aug 2009 16:10:12 -0400
X-Google-Sender-Auth: fd11b7e03532dba4
Message-ID: <118a63b80908161310r69c0810fg247341f09ced8932@mail.gmail.com>
Subject: Re: [PATCH] Revert netlink ABI change to gnet_stats_basic
From: Michael Spang <mspang@csclub.uwaterloo.ca>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: "David S. Miller" <davem@davemloft.net>,
       LKML <linux-kernel@vger.kernel.org>,
       Linux Netdev List <netdev@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 16, 2009 at 3:36 PM, Eric Dumazet<eric.dumazet@gmail.com> wrote:
> Michael Spang a écrit :
>
> OK, then we are stuck to use a separate definition for user land
> and kernel land, or risk various side effects, like performance hit
> and security risk.
>
> Thanks a lot Michael
>
> [PATCH] net: restore gnet_stats_basic to previous definition

Applied it and it works for me, thanks.

Michael
