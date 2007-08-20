Return-Path: <linux-kernel-owner+w=401wt.eu-S1757817AbXHTHzc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757817AbXHTHzc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2007 03:55:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751502AbXHTHzV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Aug 2007 03:55:21 -0400
Received: from smtp.ustc.edu.cn ([202.38.64.16]:57202 "HELO ustc.edu.cn"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1751577AbXHTHzS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2007 03:55:18 -0400
Message-ID: <387596515.30798@ustc.edu.cn>
X-EYOUMAIL-SMTPAUTH: wfg@mail.ustc.edu.cn
Date: Mon, 20 Aug 2007 15:55:15 +0800
From: Fengguang Wu <wfg@mail.ustc.edu.cn>
To: Ray Lee <ray-lk@madrabbit.org>
Cc: Andrew Morton <akpm@osdl.org>, Matt Mackall <mpm@selenic.com>,
       John Berthels <jjberthels@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/4] process memory footprint info in
	proc/<pid>/[s|p]maps v2
Message-ID: <20070820075515.GA10476@mail.ustc.edu.cn>
References: <387510147.18695@ustc.edu.cn> <2c0942db0708192015u2759ccfby320549cd6393dff3@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2c0942db0708192015u2759ccfby320549cd6393dff3@mail.gmail.com>
X-GPG-Fingerprint: 53D2 DDCE AB5C 8DC6 188B  1CB1 F766 DA34 8D8B 1C6D
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 19, 2007 at 08:15:01PM -0700, Ray Lee wrote:
> On 8/19/07, Fengguang Wu <wfg@mail.ustc.edu.cn> wrote:
> > Inspired by Matt Mackall's pagemap patches and ideas, I worked up these
> > textual interfaces that achieve the same goals. The patches run OK
> > under different sized reads.
> [...]
> > 2b7d6e8f3000-2b7d6ea40000 r-xp 00000000 08:01 1564031                    /lib/libc-2.6.so
> > 0       2       YRAU___ 81
> > 2       1       YRAU___ 80
> > 3       1       YRAU___ 81
> > 4       1       YRAU___ 72
> > 5       1       YRAU___ 77
> > 6       1       YRAU___ 79
> > 7       1       YRAU___ 73
> > 8       1       YRAU___ 79
> > 9       1       YRAU___ 78
> > a       1       YRAU___ 77
> > b       1       YRAU___ 72
> > c       1       YRAU___ 75
> > d       1       YRAU___ 81
> > e       1       YRAU___ 72
> > f       1       YRAU___ 78
> > 10      1       YRAU___ 81
> > 11      1       YRAU___ 78
> > 12      1       YRAU___ 80
> > 13      1       YRAU___ 78
> > 14      2       YRAU___ 81
> > 16      1       YRAU___ 49
> > 17      6       YRAU___ 41
> > 1d      1       YRAU___ 80
> > 2a      1       YRAU___ 44
> > 2b      1       YRAU___ 69
> > 2c      1       YRAU___ 28
> > 31      1       YRAU___ 79
> > 32      1       YRAU___ 49
> > 33      1       YRAU___ 73
> > 34      1       YRAU___ 57
> > 35      1       YRAU___ 67
> > 42      1       YRAU___ 77
> > 43      3       YRAU___ 78
> > 46      1       YRAU___ 77
> > 47      1       YRAU___ 70
> > 48      1       YRAU___ 15
> > 4d      1       YRAU___ 78
> > 5f      1       YRAU___ 78
> > 60      1       YRAU___ 75
> > 61      1       YRAU___ 72
> > 62      1       YRAU___ 67
> > 63      1       YRAU___ 59
> > 68      1       YRAU___ 63
> > 69      1       YRAU___ 61
> > 6a      1       YRAU___ 63
> > 6b      1       YRAU___ 75
> > 6c      1       YRAU___ 76
> > 6d      1       YRAU___ 81
> > 6e      1       YRAU___ 77
> > 6f      1       YRAU___ 79
> > 70      1       YRAU___ 44
> > 71      1       YRAU___ 79
> > 72      1       YRAU___ 78
> > 73      1       YRAU___ 79
> > 74      1       YRAU___ 46
> > 75      1       YRAU___ 78
> > 76      1       YRAU___ 60
> > 78      1       YRAU___ 79
> > 79      1       YRAU___ 81
> > 7a      1       YRAU___ 80
> > 7e      1       YRAU___ 41
> > 8a      1       YRAU___ 36
> > 8b      1       YRAU___ 72
> > 8c      1       YRAU___ 28
> > 8d      1       YRAU___ 21
> > 91      2       YRAU___ 19
> > 99      1       YRAU___ 62
> > 9a      1       YRAU___ 76
> > 9b      1       YRAU___ 72
> > c4      1       YRAU___ 80
> > c5      1       YRAU___ 82
> > c6      1       YRAU___ 81
> > cb      1       YRAU___ 42
> > cc      1       YRAU___ 79
> > cd      1       YRAU___ 26
> > cf      1       YRAU___ 12
> > d0      1       YRAU___ 77
> > d1      1       YRAU___ 38
> > d2      1       YRAU___ 45
> > d3      1       YRAU___ 66
> > d4      1       YRAU___ 71
> > e0      1       YRAU___ 52
> > 106     1       YRAU___ 33
> > 107     1       YRAU___ 14
> > 108     1       YRAU___ 63
> > 109     1       YRAU___ 57
> > 10b     1       YRAU___ 70
> > 10c     1       YRAU___ 63
> > 118     1       YRAU___ 65
> > 119     1       YRAU___ 78
> > 11a     1       YRAU___ 69
> > 11b     1       YRAU___ 68
> > 11e     2       YRAU___ 62
> > 120     1       YRAU___ 74
> > 121     1       YRAU___ 42
> > 125     1       YRAU___ 17
> 
> Eh, I'd think that pivoting the data set would be a much more natural
> (& therefore shorter) representation.
> 
> YRAU___ 0,2:81 2:80 3:81 4:72 5:77 6:79 7:73 8:79 9:78
> ...versus...
> > 0       2       YRAU___ 81
> > 2       1       YRAU___ 80
> > 3       1       YRAU___ 81
> > 4       1       YRAU___ 72
> > 5       1       YRAU___ 77
> > 6       1       YRAU___ 79
> > 7       1       YRAU___ 73
> > 8       1       YRAU___ 79
> > 9       1       YRAU___ 78
> 
> So, flags followed by a list of offset[,length]:usage. If the flags
> change, start a new line. If you get a line that's too long, start a
> new line.
> 
> No?

It's an interesting suggestion: the compression ratio could be doubled
on average.  Thank you!

However I still appreciate the 'beauty' of tabbed output ;-)

I'm working on an interface with similar output(see filecache below). It is
less likely to be improved by the new format - and I want the two interfaces to
be consistent.


As for the format, I'm not quite sure of two things:
- should hex values be used for offset/len?
  Hex values are less user friendly but more consistent with the format of
  maps. For example, the 001bc000/1bc, 007d1000/7d1 below:
007bc000-007d1000 rw-p 001bc000 08:01 199284                             /usr/bin/Xorg
                       ^^^^^
1bc     1       YR_U___ 1
^^^
1bd     5       Y_A_P__ 1
1c3     3       Y_A_P__ 1
1c6     5       YR_U___ 1
1cb     1       Y_A_P__ 1
1cc     1       YR_U___ 1
1cd     4       Y_A_P__ 1
007d1000-0108a000 rw-p 007d1000 00:00 0                                  [heap]
                       ^^^^^
7d1     4       Y_A_P__ 1
^^^
7d6     3       Y_A_P__ 1
7da     5       Y_A_P__ 1
7e0     41      Y_A_P__ 1

- should the page size be printed as a file header(offset/len are in page
  units)?  e.g.
# page size 4096
...
But it is also available via the getpagesize() call.

I'd appreciate it a lot if you or other people could give advices on them.

Thank you,
Fengguang
---

filecache: show cached files and their cached pages
===================================================

bash-3.2# cat /proc/filecache
# filecache 1.0
#      ino    cached cached% refcnt state   dev          file
         0       568       0      0    --   00:02(bdev)  (03:00)
    176359      1164      95      2    d-   03:00(hda)   /lib/libc-2.3.6.so
    176355        92     100      2    d-   03:00(hda)   /lib/ld-2.3.6.so
     96199        12     100      0    d-   03:00(hda)   /bin/cat
     32286         4     100      0    --   03:00(hda)   /etc/mtab
     96194        40     100      0    d-   03:00(hda)   /bin/mount
    529061         4     100      0    --   03:00(hda)   /usr/share/terminfo/l/linux
     48099         4     100      0    --   03:00(hda)   /.bash_history
    176633        40     100      1    --   03:00(hda)   /lib/libnss_files-2.3.6.so
    176635        36     100      1    --   03:00(hda)   /lib/libnss_nis-2.3.6.so
    176630        76     100      1    --   03:00(hda)   /lib/libnsl-2.3.6.so
    176631        36     100      1    --   03:00(hda)   /lib/libnss_compat-2.3.6.so
    176362        12     100      1    --   03:00(hda)   /lib/libdl-2.3.6.so
    176690       264     100      1    --   03:00(hda)   /lib/libncurses.so.5.5
     96202       244     100      0    --   03:00(hda)   /bin/bash
        73       568     100      1    --   00:01(rootfs)        /dev/root
bash-3.2# echo /lib/libc-2.3.6.so > /proc/filecache
bash-3.2# cat /proc/filecache
# file /lib/libc-2.3.6.so
# flags R:referenced A:active U:uptodate D:dirty W:writeback M:mmap
# idx   len     state   refcnt
0       16      RAU__M  3
16      3       __U___  1
19      1       R_U__M  2
1a      5       __U___  1
1f      1       RAU__M  3
20      1       __U___  1
21      1       R_U__M  2
22      2       RAU__M  3
24      1       R_U__M  2
25      1       __U___  1
26      1       RAU__M  3
27      2       __U___  1
29      2       RAU__M  2
2b      2       RAU__M  3
2d      2       R_U__M  2
2f      9       __U___  1
38      1       R_U__M  2
39      1       __U___  1
3a      5       RAU__M  2
3f      1       R_U__M  2
40      4       __U___  1
44      1       RAU__M  2
45      3       __U___  1
48      6       R_U__M  2
4e      4       __U___  1
52      1       R_U__M  2
53      2       RAU__M  2
55      1       R_U__M  2
56      2       RAU__M  2
58      1       R_U__M  2
59      2       __U___  1
5b      1       RAU__M  2
5c      1       R_U__M  2
5d      5       RAU__M  2
62      1       RAU__M  3
63      2       RAU__M  2
65      1       R_U___  1
66      3       RAU__M  2
69      1       __U___  1
6a      3       RAU__M  3
6d      1       R_U__M  2
6e      3       __U___  1
71      1       R_U__M  2
72      c       __U___  1
7e      1       R_U__M  2
7f      9       __U___  1
88      2       R_U__M  2
8a      1       __U___  1
8b      1       R_U__M  2
8c      2       RAU__M  2
8e      1       R_U__M  2
8f      9       __U___  1
9f      f       __U___  1
ae      2       RAU__M  2
b0      9       __U___  1
b9      2       RAU__M  3
bb      1       RAU__M  2
bc      4       __U___  1
c0      2       RAU__M  3
c2      1       R_U__M  2
c3      2       __U___  1
c5      1       RAU__M  2
c6      2       R_U__M  2
c8      1       RAU__M  3
c9      1       RAU__M  2
ca      c       __U___  1
d6      1       RAU__M  3
d7      3       __U___  1
da      3       R_U__M  2
dd      f       __U___  1
f3      5       __U___  1
f8      4       R_U__M  2
fc      1       __U___  1
fd      2       R_U__M  2
ff      1       RAU__M  3
100     1       R_U__M  2
101     2       __U___  1
103     1       RAU__M  3
104     5       __U___  1
109     1       RAU__M  3
10a     a       __U___  1
114     1       RAU__M  2
115     1       RAU__M  3
116     1       __U___  1
117     1       RAU__M  2
118     2       R_U__M  2
11a     2       __U___  1
11c     1       RAU__M  3
11d     1       RAU__M  2
11e     1       RAU__M  3
11f     2       R_U__M  2
121     1       __U___  1
122     1       R_U__M  2
123     4       __U___  1
127     4       RAU___  1
12b     6       __U___  1

