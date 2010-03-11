Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751888Ab0CKGKn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Mar 2010 01:10:43 -0500
Received: from web7608.mail.in.yahoo.com ([202.86.4.27]:33581 "HELO
	web7608.mail.in.yahoo.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751729Ab0CKGKl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Mar 2010 01:10:41 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.co.in;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=2lRV4VsQTAwYdxzlyFroJReqTgpfCu55Qhw/8QnKxlVk3+aMpe6Itzi8CCPU4YMFKMU9GId7ip66BVahYpfO1hBK9ovCpcAisHlst4poM5mnBqNTEGyVm5Mx+VJVyak+yLCTkzFYLxyRuMlD/uQmyh6ZZZp+MMwDn6RscYIpeoI=;
Message-ID: <609314.24705.qm@web7608.mail.in.yahoo.com>
X-YMail-OSG: lcHYiSoVM1nBPHW783VRnqiY9XzL8C5LGN9KuvAJWLnvu1C
 k59DXAj9bhLALN3LcxTcJNj2.Y0hTyodieoK1KPUcxzFw1VR3HNUGeQvsdo_
 5x0PXl4CMjJRfftvztoJLMPGJP.f5rUXgMgOp9J1t9gC3_5wIgVYNvUAVKKr
 _Qy0qWnRNWeaUb1HamPOPSGWUkdpQn8Q.4O_fB6YX7Edql4GcjLEkitGozB3
 PpphnlDi4NNtorYLlsgVI279H_faVKWsVZlhIkD62Ubn.aKHljbFXk3eEA..
 qf2zpMVm8TY.JDW9yYGrE64dcO6Q7QZAF_wI-
X-Mailer: YahooMailClassic/9.2.12 YahooMailWebService/0.8.100.260964
Date: Thu, 11 Mar 2010 11:40:38 +0530 (IST)
From: Srinivas Nayak <sinu_nayak2001@yahoo.co.in>
Subject: Re: BUG: Is it a bug in Linux time() function or Linux OS calls?
To: john stultz <johnstul@us.ibm.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <1f1b08da1003100919k57d8cc6au6ff753ebf5b6c2f8@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear John,

Thanks for your answer. This is informative.

With best regards,
 
Yours sincerely,
Srinivas Nayak
 
My Home page: http://www.mathmeth.com/sn/
My Blog: http://srinivas-nayak.blogspot.com


--- On Wed, 10/3/10, john stultz <johnstul@us.ibm.com> wrote:

> From: john stultz <johnstul@us.ibm.com>
> Subject: Re: BUG: Is it a bug in Linux time() function or Linux OS calls?
> To: "Srinivas Nayak" <sinu_nayak2001@yahoo.co.in>
> Cc: linux-kernel@vger.kernel.org
> Date: Wednesday, 10 March, 2010, 10:49 PM
> On Tue, Mar 9, 2010 at 11:59 PM,
> Srinivas Nayak
> <sinu_nayak2001@yahoo.co.in>
> wrote:
> > I wrote a small program, that creates files at an
> interval of 1 minute. But the time at which the file is
> created and last written and the last modification time of
> the file as shown by ls command differs by 1 second. The
> code and the output is presented below. please let me know
> where could be the bug?
> >
> [snip]
> > Some system info:
> > ===========
> > Linux new 2.6.24-19-server #1 SMP Wed Jun 18 14:44:47
> UTC 2008 x86_64 GNU/Linux
> > Gnu C                  4.2.4
> > Linux C Library        2.7
> > binutils               2.18.0.20080103
> > util-linux             2.13.1
> > Console-tools          0.2.3
> > Sh-utils               6.10
> > ===========
> 
> Hrm. Is CONFIG_NO_HZ enabled?  If so this is a known
> issue. The
> filesystem timestamps use xtime, which is normally updated
> every HZ.
> However to reduce overhead with NO_HZ we changed the update
> to be a
> half-second, which can cause issues like what you
> describe.
> 
> The issue has since been resolved, so I'd be interested to
> hear if you
> can still reproduce it on a more recent kernel.
> 
> thanks
> -john
> 


      Your Mail works best with the New Yahoo Optimized IE8. Get it NOW! http://downloads.yahoo.com/in/internetexplorer/
