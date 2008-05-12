Return-Path: <linux-kernel-owner+w=401wt.eu-S1758049AbYELUN6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758049AbYELUN6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2008 16:13:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751197AbYELUNp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 May 2008 16:13:45 -0400
Received: from terminus.zytor.com ([198.137.202.10]:41706 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753720AbYELUNm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2008 16:13:42 -0400
Message-ID: <4828A4CF.9010103@zytor.com>
Date: Mon, 12 May 2008 13:13:03 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Oliver Hartkopp <oliver@hartkopp.net>
CC: Romano Giannetti <romanol@upcomillas.es>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       akpm@linux-foundation.org, Greg KH <greg@kroah.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC] Kernel naming convention in the merge phase
References: <4818F093.3070105@hartkopp.net> <4819050C.9060800@zytor.com>	 <48198873.7030503@hartkopp.net>  <481A06C0.6070500@zytor.com> <1210163964.14371.1.camel@localhost> <48282C69.2070006@hartkopp.net> <48286364.7010107@zytor.com> <48288E4E.3080107@hartkopp.net> <48289C59.5040401@zytor.com> <48289F00.9010406@hartkopp.net>
In-Reply-To: <48289F00.9010406@hartkopp.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oliver Hartkopp wrote:
> 
> This is no real detail. How can -rc0 break a naming scheme for a robot,
> when -rc1 doesn't?
> 

Because of things like:

- regexp patterns like -(rc|pre)([1-9][0-9]*)
- using zero to mean "no rc/pre"
- assuming 1 is the immediate decendent of the previous one

So on, etc, yadda yadda...

	-hpa
