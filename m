Return-Path: <linux-kernel-owner+w=401wt.eu-S1753495AbXFMVf3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753495AbXFMVf3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2007 17:35:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751170AbXFMVfU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jun 2007 17:35:20 -0400
Received: from nz-out-0506.google.com ([64.233.162.235]:26072 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752525AbXFMVfT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2007 17:35:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=BAGOAKtBgYhi0gIDJPzcld/+FoJBKSedImscsceCriLdjn/tuCkZGRuw/6fRzhOecKqm9qStAKau8wv35iHw4XPC5/yFXg4VGnrPLTqy5t0NJdwzjMArw0S6AqSBErS1BGAnySBiVSVOrz/Kzmq1i7X05F7qRKWp4zjgMB3bS64=
Message-ID: <9d732d950706131435s636b852di98026aed1d9a6ac6@mail.gmail.com>
Date: Thu, 14 Jun 2007 06:35:17 +0900
From: "Toshiharu Harada" <haradats@gmail.com>
To: "Rik van Riel" <riel@redhat.com>
Subject: Re: [RFC] TOMOYO Linux
Cc: "Stephen Smalley" <sds@tycho.nsa.gov>,
       "Toshiharu Harada" <haradats@nttdata.co.jp>,
       linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org
In-Reply-To: <46704D49.8010308@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <466FA71C.1020309@nttdata.co.jp>
	 <1181743635.17547.350.camel@moss-spartans.epoch.ncsc.mil>
	 <9d732d950706130722g12a22604p223381a8e281a4a1@mail.gmail.com>
	 <46704D49.8010308@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

2007/6/14, Rik van Riel <riel@redhat.com>:
> > So I think pathname based call chains are advantages for
> > at least auditing and profiling.
>
> SELinux audit logs (well, whatever is in /var/log/audit on
> my system) does show the path names of objects that fail to
> be accessed as well as the name and context of the processes
> trying to access them.
>
> This is with standard Fedora and RHEL installations.

Thank you for your comment.

SELinux has a well designed robust and flexible functions.
So it should be used for everywhere.  I understand it.
As you mentioned one can analyze the system (process)
behaviors from AVC logs. But the maintenance cost is not trivial.

If logging with process context is the only purpose,
current TOMOYO Linux can do it with no hustle at all.
Installation takes just 15 minutes. Please think it as something like
TOYOTA Prius. It's a compact and economical car.
Volvo is known by its security, but we don't have to use only Volvo.

TOMOYO Linux and its underlying idea are free and
you don't have to find a garage. :-)

Cheers,
Toshiharu Harada
