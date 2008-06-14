Return-Path: <linux-kernel-owner+w=401wt.eu-S1754319AbYFNPbb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754319AbYFNPbb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jun 2008 11:31:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752439AbYFNPbU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Jun 2008 11:31:20 -0400
Received: from fg-out-1718.google.com ([72.14.220.154]:24841 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752377AbYFNPbT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jun 2008 11:31:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=PWegfW24aapURGc+l+0W83Cib9AG0YnN28YrF9eUSASax5nwZo7sam3hjiYhATVvh2
         gZzY6gRsoJI9syv54+SGRdQwV2yJN5EYKco5ls5OhD69O7beG1DogcZtNtt8HWB5svyf
         B+5rWtxj3QgOko4pTLPHgXXcwXPm9HW80I8CA=
Message-ID: <e2e108260806140831s40f36a95s1a412cec4dc47f31@mail.gmail.com>
Date: Sat, 14 Jun 2008 17:31:18 +0200
From: "Bart Van Assche" <bart.vanassche@gmail.com>
To: "Marco Barbero" <marco.barbero@gmail.com>
Subject: Re: OOM killer invoked on 2.6.24.4
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <e1aa27e00806140313o5a62c618kb41b892b7b29e235@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <e1aa27e00806140313o5a62c618kb41b892b7b29e235@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 14, 2008 at 12:13 PM, Marco Barbero <marco.barbero@gmail.com> wrote:
> samba/slapd/heartbeat/drbd/mon
...
> Jun 14 01:00:17 pippo kernel: Out of memory: kill process 6873 (slapd)
> score 5003 or a child
> Jun 14 01:00:17 pippo kernel: Killed process 6873 (slapd)
>
> Anyone can help me in understanding what went wrong? And if I need to
> upgrade to last kernel version?

One or more processes on your system used too much memory. Dumping the
output of the following command periodically (e.g. every 10 minutes)
to a file will tell you which process is using too much memory:

{ ps aux | head -n 1; ps aux | sort -n +4 | tail -n 10; }

Bart.
