Return-Path: <linux-kernel-owner+w=401wt.eu-S1757029AbYDRHVj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757029AbYDRHVj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2008 03:21:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751521AbYDRHVc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Apr 2008 03:21:32 -0400
Received: from s200aog11.obsmtp.com ([207.126.144.125]:47896 "EHLO
	s200aog11.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751267AbYDRHVb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2008 03:21:31 -0400
Message-ID: <48084B60.3040208@st.com>
Date: Fri, 18 Apr 2008 09:18:56 +0200
From: Richard MUSIL <richard.musil@st.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
Cc: Willy Tarreau <w@1wt.eu>, linux-kernel@vger.kernel.org
Subject: Re: Problem with accessing stable git over http
References: <47EA26E4.8060602@st.com> <20080404050718.GE23796@1wt.eu> <47F5E701.6020706@st.com> <4804A58E.5070104@st.com> <20080417212849.GA17653@kroah.com>
In-Reply-To: <20080417212849.GA17653@kroah.com>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 17.4.2008 23:28, Greg KH wrote:
> On Tue, Apr 15, 2008 at 02:54:38PM +0200, Richard MUSIL wrote:
>> Just to give an update on the topic. I tried to clone stable 2.6.24.y
>> branch and got a bit more info then on fetch:
>>
>>> rmusil@prglx09 ~ $ git clone http://www.kernel.org/pub/scm/linux/kernel/git/stable/linux-2.6.24.y.git linux-2.6.24.y
>>> Initialized empty Git repository in /home/rmusil/linux-2.6.24.y/.git/
>>> Cannot get remote repository information.
>>> Perhaps git-update-server-info needs to be run there?
>>> rmusil@prglx09 ~ $
>> This is from machine which is behind proxy, but I tried it from another
>> one, which has direct access and got exactly the same output.
>> Is it possible that perhaps git-update-server-info should be run there?
>> Who is responsible for the repository maintenance?
>> So far it looks like the http access is simply not set up on the repo,
>> even though it is advertised on project web page.
>>
>> Greg, could you help me with this?
> 
> I've now run git-update-server-info on that repo, let me know if that
> solves the problem or not.

Thanks, this seems has solved the problem. Now, I can fetch from stable
branch over http without any problems.

Richard
