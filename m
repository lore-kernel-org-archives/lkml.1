Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750902Ab0CIFGU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Mar 2010 00:06:20 -0500
Received: from qw-out-2122.google.com ([74.125.92.27]:57030 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750715Ab0CIFGQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Mar 2010 00:06:16 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=C8YgKZN+PtOAQxJqgGGpQZTDWEMSr2sAWyQVmyx56k5PitYePR/B1CeQb7JdF6TQN5
         42uCP/evJ6O1h8IO3qGhGnpmKG+pvpKhEdOYY3VwtS6wk3GhOByvOOEULhQz5tuf42DD
         ZmsA33CHJLq7BB1yT3bp5NiTKXoeWxrcjN+6Y=
MIME-Version: 1.0
In-Reply-To: <1268103085.10871.1862.camel@gandalf.stny.rr.com>
References: <2375c9f91003022204p5bdab1fdj3b3500998575fc28@mail.gmail.com>
	 <1267710847.10871.102.camel@gandalf.stny.rr.com>
	 <2375c9f91003042014y17588865g8f9110e666ac2456@mail.gmail.com>
	 <2375c9f91003042316g6e774d60n90dfc4784d3b66bf@mail.gmail.com>
	 <1267801603.10871.1725.camel@gandalf.stny.rr.com>
	 <2375c9f91003071831x4104dd8dp82967c0409391bd5@mail.gmail.com>
	 <2375c9f91003081840w5419d847q8ffd8b6ce46d86fb@mail.gmail.com>
	 <1268103085.10871.1862.camel@gandalf.stny.rr.com>
Date: Tue, 9 Mar 2010 13:06:13 +0800
Message-ID: <2375c9f91003082106k6de11672y1b832223aa7ccd60@mail.gmail.com>
Subject: Re: 2.6.33: ftrace triggers soft lockup
From: =?UTF-8?Q?Am=C3=A9rico_Wang?= <xiyou.wangcong@gmail.com>
To: rostedt@goodmis.org
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 9, 2010 at 10:51 AM, Steven Rostedt <rostedt@goodmis.org> wrote:
> On Tue, 2010-03-09 at 10:40 +0800, Américo Wang wrote:
>
>> > I will try this now.
>> >
>>
>> Unfortunately, this doesn't help.
>>
>> What is worse, I got another soft lockup, although I already turned LOCKDEP off.
>
> Hmm, this really sounds like somethings badly broken.
>
> What version of GCC are you using?

# gcc -v
Using built-in specs.
Target: x86_64-redhat-linux
Configured with: ../configure --prefix=/usr --mandir=/usr/share/man
--infodir=/usr/share/info --enable-shared --enable-threads=posix
--enable-checking=release --with-system-zlib --enable-__cxa_atexit
--disable-libunwind-exceptions --enable-libgcj-multifile
--enable-languages=c,c++,objc,obj-c++,java,fortran,ada
--enable-java-awt=gtk --disable-dssi --enable-plugin
--with-java-home=/usr/lib/jvm/java-1.4.2-gcj-1.4.2.0/jre
--with-cpu=generic --host=x86_64-redhat-linux
Thread model: posix
gcc version 4.1.2 20080704 (Red Hat 4.1.2-46)
