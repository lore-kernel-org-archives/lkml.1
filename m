Return-Path: <linux-kernel-owner+w=401wt.eu-S1754874AbYCQMup@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754874AbYCQMup (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2008 08:50:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753358AbYCQMuf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Mar 2008 08:50:35 -0400
Received: from wr-out-0506.google.com ([64.233.184.225]:49589 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752854AbYCQMud (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2008 08:50:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=WGrXSzyulZL7/xXDYPkU1BWzOpoWwb9hKqZsnoF0K/LAcUxTF5adSLJORGALLNG5KHZsA7mcOzJ35jy0t6x3u/5oNzBcB2vCKvPp+G2aFy3vpvp6l9LWb3aPh3TcKs7CNdG2x7blMoj0i0c06NT7gQjeJg5ysiCE8GPxmfUP50g=
Message-ID: <939d53060803170550r46a7e93ex31c166fff86bcf50@mail.gmail.com>
Date: Mon, 17 Mar 2008 13:50:29 +0100
From: "Benjamin Thery" <ben.thery@gmail.com>
To: "Daniel Lezcano" <dlezcano@fr.ibm.com>
Subject: Re: [2.6.25-rc5-mm1] regression: cannot run Postfix sendmail command as non-root
Cc: "Tilman Schmidt" <tilman@imap.cc>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       "David Miller" <davem@davemloft.net>, pekkas@netcore.fi,
       yoshfuji@linux-ipv6.org
In-Reply-To: <47DE4B7B.9040504@fr.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080311011434.ad8c8d7d.akpm@linux-foundation.org>
	 <47D98510.60801@imap.cc> <47D9A8DF.30809@fr.ibm.com>
	 <47D9C1F0.6050803@imap.cc> <47DE4B7B.9040504@fr.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I also tried to reproduce your problem with Postfix (on a Debian
distro) but failed to
obtain the error message.

While googling for the error string, I found this link which report
the same kind of
error when Postfix is used with grsecurity (in 2006):

http://blog.jensthebrain.de/archives/2006/12/11/IPv6-Probleme-mit-Postfix-und-grsecurity

I barely understand German so I'm not sure it is related to your problem.

Benjamin


On Mon, Mar 17, 2008 at 11:44 AM, Daniel Lezcano <dlezcano@fr.ibm.com> wrote:
> Tilman Schmidt wrote:
>  > Am 13.03.2008 23:21 schrieb Daniel Lezcano:
>  >> Tilman Schmidt wrote:
>  >
>  >>> ts@xenon:~/kernel> /usr/sbin/sendmail -t < patch-usb-reduce-syslog-clutter-v3
>  >>> postdrop: warning: can't open /proc/net/if_inet6 (Permission denied) - skipping IPv6 configuration
>  >>> postdrop: fatal: parameter inet_interfaces: no local interface found for ::1
>  >>> sendmail: warning: command "/usr/sbin/postdrop -r" exited with status 1
>  >>> sendmail: fatal: ts(1000): unable to execute /usr/sbin/postdrop -r: Success
>  >>> ts@xenon:~/kernel>
>  >>>
>  >>> and unsurprisingly, the mail is not sent. If I do the same as root,
>  >>> everything works as usual, there is no console output from the
>  >>> sendmail command, and the mail goes out as it should. All other
>  >>> networking applications appear to be running normally.
>  >
>  >> Is it possible to have your config file used to compile the kernel ?
>  >
>  > Sure. You can find it at
>  > http://gollum.phnxsoft.com/~ts/linux/config-2.6.25-rc5-mm1
>
>  Thanks,
>
>  I was not able to reproduce it, but I think I didn't configured postfix
>  as I should had. What version do you use ?
>  If I may ask you, can you put your postfix configuration file and a
>  strace -f of your failing command ? on your website, that will help me a
>  lot to investigate.
>
>    -- Daniel
>
>
> --
>  To unsubscribe from this list: send the line "unsubscribe netdev" in
>  the body of a message to majordomo@vger.kernel.org
>  More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
