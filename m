Return-Path: <linux-kernel-owner+w=401wt.eu-S1762203AbZEGRuR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762203AbZEGRuR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 May 2009 13:50:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752498AbZEGRuB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 May 2009 13:50:01 -0400
Received: from mail-gx0-f166.google.com ([209.85.217.166]:35337 "EHLO
	mail-gx0-f166.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751626AbZEGRuA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 May 2009 13:50:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=A1eh5r/qoD9FW8zP1HSCurspaBGCLFRjLCOcB3daOIDn/7VsnHLcA6YlVRihPr71fF
         4p9pcf7SR+wLnlB7zH3K7p5kssJsv83byDZ6uNdeU6xIVrD7ZlUZvGwW9j8+F/Pqt0Db
         9q/UUnTOR5SR2BjM5C3/CS0AhcLCP+vsaRf64=
MIME-Version: 1.0
In-Reply-To: <20090507172301.GA28595@foursquare.net>
References: <20090506215017.GA21981@kroah.com>
	 <20090507172301.GA28595@foursquare.net>
Date: Thu, 7 May 2009 12:49:59 -0500
Message-ID: <524f69650905071049j28b23b8eg6aac203246af0992@mail.gmail.com>
Subject: Re: [patch 00/58] 2.6.29.3-stable review
From: Steve French <smfrench@gmail.com>
To: Chris Frey <cdfrey@foursquare.net>, Suresh Jayaraman <sjayaraman@suse.de>
Cc: Greg KH <gregkh@suse.de>, chrisw@sous-sol.org, jlayton@redhat.com,
       linux-kernel@vger.kernel.org, stable@kernel.org,
       Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 7, 2009 at 12:23 PM, Chris Frey <cdfrey@foursquare.net> wrote:
> On Wed, May 06, 2009 at 02:50:17PM -0700, Greg KH wrote:
>> This is the start of the stable review cycle for the 2.6.29.3 release.
>> There are 58 patches in this series, all will be posted as a response to
>> this one.
>
> Maybe I'm missing something, but I don't see any of
> the fs/cifs/connect.c security fixes from commits such as
> f083def68f84b04fe3f97312498911afce79609e.  I was hoping this would make
> it into 2.6.29.3.
>
> For reference, this was discussed on full-disclosure:
>        http://marc.info/?l=full-disclosure&m=123936563230145&w=2
>        (near the end of Andreas's post)
>
> Jeff and Steve mentioned last week that they were working on other related
> cleanups as well, that they hoped to push to stable.

The cleanup and rewrite of some of the Unicode string handling functions was
too large for stable,  but the potential buffer overrun fixes were small
enough to submit, had been collected (and cleaned up so that they
could merge) for stable submission by Suresh  (Jeff and I acked
them over the last two days)

01-cifs-fix-buffer-size-for-nativeFileSystem
02-cifs-fix-temp-buffer-size-in-cifs_readdir
03-cifs-fix-dest-buffer-size-in-cifs_strncpy_to_host
04-cifs-fix-cifs_convertUCSpath
05-cifs-fix-unicode-string-alignment-in-session-setup

I am not aware of any others that are missing.

Suresh,
Are we missing any?

-- 
Thanks,

Steve
